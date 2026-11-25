# Throwaway test: can a security group rule in VPC B reference a Pod security
# group (branch ENI, SGPP strict mode) in VPC A across a Transit Gateway?
# One account, one Region. No public IPs on instances, private-only EKS API.

terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.0" }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags { tags = { Project = "tgw-sgref-test" } }
}

locals {
  name   = "sgref"
  azs    = ["${var.region}a", "${var.region}c"]
  a_cidr = "10.50.0.0/16"
  b_cidr = "10.60.0.0/16"
}

# ---------------- VPC A: EKS ----------------
resource "aws_vpc" "a" {
  cidr_block           = local.a_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "${local.name}-vpc-a" }
}

resource "aws_subnet" "a_public" {
  vpc_id            = aws_vpc.a.id
  cidr_block        = "10.50.0.0/24"
  availability_zone = local.azs[0]
  tags              = { Name = "${local.name}-a-public" }
}

resource "aws_subnet" "a_private" {
  count             = 2
  vpc_id            = aws_vpc.a.id
  cidr_block        = cidrsubnet(local.a_cidr, 8, count.index + 1) # 10.50.1.0/24, 10.50.2.0/24
  availability_zone = local.azs[count.index]
  tags              = { Name = "${local.name}-a-private-${count.index}" }
}

resource "aws_subnet" "a_tgw" {
  count             = 2
  vpc_id            = aws_vpc.a.id
  cidr_block        = cidrsubnet("10.50.100.0/24", 4, count.index) # /28
  availability_zone = local.azs[count.index]
  tags              = { Name = "${local.name}-a-tgw-${count.index}" }
}

resource "aws_internet_gateway" "a" {
  vpc_id = aws_vpc.a.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

# Outbound only (image pulls, SSM). Nothing inbound from the internet.
resource "aws_nat_gateway" "a" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.a_public.id
  depends_on    = [aws_internet_gateway.a]
}

resource "aws_route_table" "a_public" {
  vpc_id = aws_vpc.a.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.a.id
  }
}

resource "aws_route_table_association" "a_public" {
  subnet_id      = aws_subnet.a_public.id
  route_table_id = aws_route_table.a_public.id
}

resource "aws_route_table" "a_private" {
  vpc_id = aws_vpc.a.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.a.id
  }
  route {
    cidr_block         = local.b_cidr
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.a]
}

resource "aws_route_table_association" "a_private" {
  count          = 2
  subnet_id      = aws_subnet.a_private[count.index].id
  route_table_id = aws_route_table.a_private.id
}

# ---------------- VPC B: target EC2 ----------------
resource "aws_vpc" "b" {
  cidr_block           = local.b_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "${local.name}-vpc-b" }
}

resource "aws_subnet" "b_private" {
  vpc_id            = aws_vpc.b.id
  cidr_block        = "10.60.1.0/24"
  availability_zone = local.azs[0]
  tags              = { Name = "${local.name}-b-private" }
}

resource "aws_subnet" "b_tgw" {
  count             = 2
  vpc_id            = aws_vpc.b.id
  cidr_block        = cidrsubnet("10.60.100.0/24", 4, count.index)
  availability_zone = local.azs[count.index]
  tags              = { Name = "${local.name}-b-tgw-${count.index}" }
}

resource "aws_route_table" "b_private" {
  vpc_id = aws_vpc.b.id
  route {
    cidr_block         = local.a_cidr
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.b]
}

resource "aws_route_table_association" "b_private" {
  subnet_id      = aws_subnet.b_private.id
  route_table_id = aws_route_table.b_private.id
}

# ---------------- Transit Gateway with SG referencing ----------------
resource "aws_ec2_transit_gateway" "this" {
  description                        = "tgw-sgref-test"
  security_group_referencing_support = "enable"
  tags                               = { Name = "${local.name}-tgw" }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "a" {
  transit_gateway_id                 = aws_ec2_transit_gateway.this.id
  vpc_id                             = aws_vpc.a.id
  subnet_ids                         = aws_subnet.a_tgw[*].id
  security_group_referencing_support = "enable"
  tags                               = { Name = "${local.name}-att-a" }
  # Test 3 toggles this attachment's option with the CLI.
  lifecycle { ignore_changes = [security_group_referencing_support] }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "b" {
  transit_gateway_id                 = aws_ec2_transit_gateway.this.id
  vpc_id                             = aws_vpc.b.id
  subnet_ids                         = aws_subnet.b_tgw[*].id
  security_group_referencing_support = "enable"
  tags                               = { Name = "${local.name}-att-b" }
}

# ---------------- Security groups ----------------
# Pod SG, attached through SecurityGroupPolicy. Outbound to VPC B uses a CIDR:
# TGW SG referencing does not apply to outbound rules.
resource "aws_security_group" "pod" {
  name        = "${local.name}-pod"
  description = "SGPP Pod SG for the TGW SG referencing test"
  vpc_id      = aws_vpc.a.id
}

resource "aws_vpc_security_group_egress_rule" "pod_to_b" {
  security_group_id = aws_security_group.pod.id
  ip_protocol       = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = local.b_cidr
}

# Target SG: inbound 8080 from the Pod SG only. No CIDR rule.
resource "aws_security_group" "db" {
  name        = "${local.name}-db"
  description = "Target SG, inbound only from the Pod SG across TGW"
  vpc_id      = aws_vpc.b.id
}

resource "aws_vpc_security_group_ingress_rule" "db_from_pod_sg" {
  security_group_id            = aws_security_group.db.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
  referenced_security_group_id = aws_security_group.pod.id
  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.a,
    aws_ec2_transit_gateway_vpc_attachment.b,
    aws_route_table.a_private,
    aws_route_table.b_private,
  ]
}

# Return traffic is allowed by SG state; no egress rule needed on the target.

# ---------------- Target EC2 in VPC B ----------------
data "aws_ssm_parameter" "al2023_arm" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
}

resource "aws_instance" "target" {
  ami                         = data.aws_ssm_parameter.al2023_arm.value
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.b_private.id
  vpc_security_group_ids      = [aws_security_group.db.id]
  associate_public_ip_address = false
  metadata_options { http_tokens = "required" }
  user_data_replace_on_change = true
  # Listens on all interfaces inside a private VPC; aws_security_group.db is the boundary.
  user_data = <<-EOT
    #!/bin/bash
    mkdir -p /srv/www && echo "sgref-target ok" > /srv/www/index.html
    cat > /etc/systemd/system/http8080.service <<'UNIT'
    [Unit]
    Description=test http server on 8080
    After=network-online.target
    [Service]
    ExecStart=/usr/bin/python3 -m http.server 8080 --directory /srv/www
    Restart=always
    [Install]
    WantedBy=multi-user.target
    UNIT
    systemctl daemon-reload
    systemctl enable --now http8080
  EOT
  tags      = { Name = "${local.name}-target" }
}

# ---------------- Flow logs on VPC B's target subnet ----------------
resource "aws_cloudwatch_log_group" "flow" {
  name              = "/${local.name}/vpc-b-flow"
  retention_in_days = 1
}

resource "aws_iam_role" "flow" {
  name = "${local.name}-flow-logs"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Principal = { Service = "vpc-flow-logs.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy" "flow" {
  role = aws_iam_role.flow.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"]
      Resource = "${aws_cloudwatch_log_group.flow.arn}:*"
    }]
  })
}

resource "aws_flow_log" "b" {
  subnet_id                = aws_subnet.b_private.id
  traffic_type             = "ALL"
  log_destination          = aws_cloudwatch_log_group.flow.arn
  iam_role_arn             = aws_iam_role.flow.arn
  max_aggregation_interval = 60
  log_format               = "$${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${action} $${flow-direction}"
}

# ---------------- EKS (private API only) ----------------
resource "aws_iam_role" "cluster" {
  name = "${local.name}-cluster"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Principal = { Service = "eks.amazonaws.com" }, Action = ["sts:AssumeRole", "sts:TagSession"] }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster" {
  for_each   = toset(["AmazonEKSClusterPolicy", "AmazonEKSVPCResourceController"])
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_eks_cluster" "this" {
  name     = local.name
  version  = var.kubernetes_version
  role_arn = aws_iam_role.cluster.arn
  vpc_config {
    subnet_ids              = aws_subnet.a_private[*].id
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  depends_on = [aws_iam_role_policy_attachment.cluster]
}

# Tests 1-3: strict mode (POD_SECURITY_GROUP_ENFORCING_MODE unset), EXTERNALSNAT=true.
# Test 4 (fallback_mode): standard mode, EXTERNALSNAT=false, so SGPP Pod traffic
# to VPC B is SNATed to the node primary IP and judged by the node SG.
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
  configuration_values = jsonencode({
    env = merge(
      { ENABLE_POD_ENI = "true" },
      var.fallback_mode
      ? { POD_SECURITY_GROUP_ENFORCING_MODE = "standard", AWS_VPC_K8S_CNI_EXTERNALSNAT = "false" }
      : { AWS_VPC_K8S_CNI_EXTERNALSNAT = "true" }
    )
  })
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "kube-proxy"
}

resource "aws_iam_role" "node" {
  name = "${local.name}-node"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy_attachment" "node" {
  for_each = toset([
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly",
    "AmazonSSMManagedInstanceCore", # SSM tunnel to the private EKS API
  ])
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "default"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = [aws_subnet.a_private[0].id]
  instance_types  = ["m5.large"] # Nitro, supports trunk ENI
  ami_type        = "AL2023_x86_64_STANDARD"
  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }
  depends_on = [aws_iam_role_policy_attachment.node, aws_eks_addon.vpc_cni, aws_route_table_association.a_private]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "coredns"
  depends_on   = [aws_eks_node_group.this]
}
