#!/usr/bin/env bash
# Tests 1-3 for TGW SG referencing to an SGPP branch ENI. Needs ./tunnel.sh running.
#   1. Pod with sg-pod (branch ENI) -> target:8080        expect OK
#   2. Pod without SecurityGroupPolicy (node SG) -> same  expect timeout
#   3. Test 1 again after disabling SG referencing on attachment A, expect timeout;
#      then re-enable and check it recovers.
# Results and VPC B flow logs go to results/<time>.txt.
set -Eeuo pipefail
cd "$(dirname "$0")"
# Credentials come from the environment: --profile is passed only when AWS_PROFILE is set.
REGION=${AWS_REGION:-${AWS_DEFAULT_REGION:-ap-northeast-2}}
K="kubectl --context sgref-tunnel"
NS=sgref
out() { terraform output -raw "$1"; }
POD_SG=$(out pod_sg_id); CLUSTER_SG=$(out cluster_sg_id); TARGET=$(out target_ip)
ATT_A=$(out attachment_a_id); LOG_GROUP=$(out flow_log_group)
mkdir -p results
RESULT=results/$(date -u +%Y%m%dT%H%M%SZ).txt
exec > >(tee "$RESULT") 2>&1
START_MS=$(( $(date +%s) * 1000 ))

cat <<EOF | $K apply -f -
apiVersion: v1
kind: Namespace
metadata: { name: $NS }
---
apiVersion: vpcresources.k8s.aws/v1beta1
kind: SecurityGroupPolicy
metadata: { name: with-sg, namespace: $NS }
spec:
  podSelector: { matchLabels: { app: with-sg } }
  securityGroups:
    groupIds: [ $POD_SG, $CLUSTER_SG ]   # cluster SG for DNS, as in the test plan
---
apiVersion: apps/v1
kind: Deployment
metadata: { name: with-sg, namespace: $NS }
spec:
  replicas: 1
  selector: { matchLabels: { app: with-sg } }
  template:
    metadata: { labels: { app: with-sg } }
    spec:
      containers:
        - { name: c, image: public.ecr.aws/amazonlinux/amazonlinux:2023, command: [sleep, infinity] }
---
apiVersion: apps/v1
kind: Deployment
metadata: { name: no-sg, namespace: $NS }
spec:
  replicas: 1
  selector: { matchLabels: { app: no-sg } }
  template:
    metadata: { labels: { app: no-sg } }
    spec:
      containers:
        - { name: c, image: public.ecr.aws/amazonlinux/amazonlinux:2023, command: [sleep, infinity] }
EOF
$K -n $NS rollout status deploy/with-sg --timeout=180s
$K -n $NS rollout status deploy/no-sg --timeout=180s

pod_of() { $K -n $NS get pod -l app="$1" -o jsonpath='{.items[0].metadata.name}'; }
WITH=$(pod_of with-sg); NOSG=$(pod_of no-sg)
echo "== pods"
$K -n $NS get pod -o wide
echo "with-sg pod-eni: $($K -n $NS get pod "$WITH" -o jsonpath='{.metadata.annotations.vpc\.amazonaws\.com/pod-eni}')"

probe() { # pod label
  local code
  code=$($K -n $NS exec "$1" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "http://$TARGET:8080/" || true)
  # curl -w prints 000 when it got no HTTP response (here: the -m 5 timeout);
  # an empty code means kubectl exec itself failed.
  case "$code" in
    200) echo "$2: OK (HTTP 200)" ;;
    000) echo "$2: FAIL (timeout)" ;;
    "")  echo "$2: FAIL (exec error)" ;;
    *)   echo "$2: FAIL (HTTP $code)" ;;
  esac
}

att_option() {
  aws ec2 describe-transit-gateway-vpc-attachments ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" \
    --transit-gateway-attachment-ids "$ATT_A" \
    --query 'TransitGatewayVpcAttachments[0].[State,Options.SecurityGroupReferencingSupport]' --output text
}
set_att() { # enable|disable
  aws ec2 modify-transit-gateway-vpc-attachment ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" \
    --transit-gateway-attachment-id "$ATT_A" --options "SecurityGroupReferencingSupport=$1" > /dev/null
  for _ in $(seq 60); do [[ "$(att_option)" == "available	$1" ]] && break; sleep 5; done
  echo "attachment A: $(att_option) at $(date -u +%T)"
}

echo "== $(date -u +%T) test 1 (sg-pod, branch ENI)"; probe "$WITH" "test 1"
echo "== $(date -u +%T) test 2 (no SGPP, node SG)";  probe "$NOSG" "test 2"

echo "== test 3 (SG referencing disabled on attachment A)"
# If the script stops before the restore below, turn referencing back on anyway.
# Ignore further signals and errors here, and wait out a pending modify first.
restore() {
  trap '' INT TERM; set +e
  echo "== restoring SG referencing on attachment A"
  for _ in $(seq 60); do [[ "$(att_option)" == available* ]] && break; sleep 5; done
  set_att enable || echo "restore failed; see README Troubleshooting"
}
trap restore EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
set_att disable
sleep 60
probe "$WITH" "test 3"
echo "== restore"
set_att enable
trap - EXIT INT TERM
sleep 60
probe "$WITH" "test 1 after re-enable"

echo "== VPC B flow logs, dstport 8080 (wait 90s for delivery)"
sleep 90
echo "interface-id srcaddr dstaddr srcport dstport protocol action direction"
aws logs filter-log-events ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" --log-group-name "$LOG_GROUP" \
  --start-time "$START_MS" --filter-pattern '[iface, src, dst, sport, dport=8080, ...]' \
  --query 'events[].message' --output text | tr '\t' '\n'
echo "pod IPs: with-sg=$($K -n $NS get pod "$WITH" -o jsonpath='{.status.podIP}') no-sg=$($K -n $NS get pod "$NOSG" -o jsonpath='{.status.podIP}')"
echo "saved: $RESULT"
