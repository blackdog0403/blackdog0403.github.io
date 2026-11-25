# Transit Gateway security group referencing with security groups for Pods

Test code for the post
[Transit Gateway security group referencing works with security groups for Pods](https://blackdog0403.github.io/networking/tgw-sg-referencing-pods/).

It checks whether a security group rule in one VPC can use an Amazon EKS Pod
security group (a branch ENI attached through a `SecurityGroupPolicy`) in
another VPC as its source when the two VPCs are connected by an AWS Transit
Gateway with security group referencing turned on.

| Test | Script | What it checks |
|------|--------|----------------|
| 1 | `run-tests.sh` | Pod with the Pod security group reaches the target (expect HTTP 200) |
| 2 | `run-tests.sh` | Pod without a `SecurityGroupPolicy` is blocked (expect timeout) |
| 3 | `run-tests.sh` | Test 1 is blocked after turning off referencing on attachment A, then recovers |
| 4 | `run-test4.sh` | Standard mode with `EXTERNALSNAT=false`: traffic uses the node IP, so only a node security group rule allows it |

Results and the target's VPC Flow Logs are written to `results/`.

## What it creates

- **VPC A** (`10.50.0.0/16`): EKS cluster (Kubernetes 1.35) with a private-only
  API endpoint, one `m5.large` managed node, the VPC CNI add-on with
  `ENABLE_POD_ENI=true`, and a NAT gateway for outbound traffic (image pulls, SSM).
- **VPC B** (`10.60.0.0/16`): one `t4g.nano` instance serving HTTP on port 8080,
  with VPC Flow Logs to CloudWatch Logs (1-day retention).
- **Transit Gateway** with security group referencing on, and one attachment per VPC.
- Security groups `sg-pod` (Pod security group) and `sg-db` (target, inbound
  8080 from `sg-pod` only), plus IAM roles for the cluster, node, and Flow Logs.

All resources are tagged `Project = tgw-sgref-test`.

No inbound path from the internet is opened: instances have no public IPs, the
EKS API endpoint is private only, and the internet gateway exists only for the
NAT gateway. You reach the cluster through a Session Manager port-forwarding
session on the node (`tunnel.sh`).

## Cost

These resources are billable (EKS control plane, NAT gateway, Transit Gateway
attachments, two EC2 instances, CloudWatch Logs). Cost depends on the Region and
how long you keep them; check current AWS pricing before you start, and destroy
everything when you are done.

## Prerequisites

- Terraform >= 1.6
- AWS CLI v2
- kubectl
- Session Manager plugin for the AWS CLI
- An AWS account where you are allowed to create these resources

Credentials come from the standard AWS environment. Set `AWS_PROFILE` (or use
any other method the AWS CLI and Terraform provider support). The scripts use
`AWS_REGION`, then `AWS_DEFAULT_REGION`, default `ap-northeast-2`; Terraform
uses the `region` variable, same default. If you change the Region, set both, for example
`export AWS_REGION=... TF_VAR_region=$AWS_REGION`. The configuration uses
Availability Zones `a` and `c` of the Region.

## Steps

```bash
# 1. Create the resources (tests 1-3 settings: strict mode, EXTERNALSNAT=true)
terraform init
terraform apply

# 2. In a separate terminal, keep the tunnel to the private EKS API open
./tunnel.sh

# 3. Tests 1-3
./run-tests.sh

# 4. Switch the VPC CNI to standard mode with EXTERNALSNAT=false, then run test 4
terraform apply -var fallback_mode=true
./run-test4.sh
```

`tunnel.sh` writes a kubeconfig context named `sgref-tunnel` that points to
`https://127.0.0.1:8445` (set `PORT` to change it). `run-test4.sh` adds a
temporary `sg-db` rule for the node security group and removes it on exit.
`terraform init` installs the AWS provider version pinned in `.terraform.lock.hcl`.

## Troubleshooting

`run-tests.sh` turns security group referencing off on attachment A for test 3
and turns it back on when it exits, even on an error or Ctrl-C. If the script is
killed before it can do that (for example with `kill -9`), turn it back on by hand:

```bash
aws ec2 modify-transit-gateway-vpc-attachment --region "${AWS_REGION:-ap-northeast-2}" \
  --transit-gateway-attachment-id "$(terraform output -raw attachment_a_id)" \
  --options SecurityGroupReferencingSupport=enable
```

## Cleanup

```bash
terraform destroy
```

Stop `tunnel.sh` first. You can also remove the `sgref-tunnel` context,
cluster, and user from your kubeconfig.
