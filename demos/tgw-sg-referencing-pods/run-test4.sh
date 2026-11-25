#!/usr/bin/env bash
# Test 4, after `terraform apply -var fallback_mode=true` (standard + EXTERNALSNAT=false).
#   4a. sg-db allows only sg-pod. with-sg Pod -> target   expect timeout (source is now the node)
#   4b. add sg-db rule source = node SG (cluster SG). with-sg and no-sg Pods  expect both OK
#   The node SG rule is removed at the end. Needs ./tunnel.sh running.
set -Eeuo pipefail
cd "$(dirname "$0")"
# Credentials come from the environment: --profile is passed only when AWS_PROFILE is set.
REGION=${AWS_REGION:-${AWS_DEFAULT_REGION:-ap-northeast-2}}
K="kubectl --context sgref-tunnel"
NS=sgref
out() { terraform output -raw "$1"; }
NODE_SG=$(out cluster_sg_id); DB_SG=$(out db_sg_id); TARGET=$(out target_ip); LOG_GROUP=$(out flow_log_group)
mkdir -p results
RESULT=results/test4-$(date -u +%Y%m%dT%H%M%SZ).txt
exec > >(tee "$RESULT") 2>&1
START_MS=$(( $(date +%s) * 1000 ))

echo "== aws-node env"
$K -n kube-system get ds aws-node -o jsonpath='{range .spec.template.spec.containers[0].env[*]}{.name}={.value}{"\n"}{end}' \
  | grep -E 'ENABLE_POD_ENI|POD_SECURITY_GROUP_ENFORCING_MODE|EXTERNALSNAT'
# Pods keep the mode they started with; recreate them.
$K -n $NS rollout restart deploy/with-sg deploy/no-sg
$K -n $NS rollout status deploy/with-sg --timeout=180s
$K -n $NS rollout status deploy/no-sg --timeout=180s
# Old pods stay phase=Running while terminating; wait until one pod per app is left.
for app in with-sg no-sg; do
  for _ in $(seq 60); do [[ $($K -n $NS get pod -l app=$app --no-headers | wc -l) -eq 1 ]] && break; sleep 3; done
done
pod_of() { $K -n $NS get pod -l app="$1" -o jsonpath='{.items[0].metadata.name}'; }
WITH=$(pod_of with-sg); NOSG=$(pod_of no-sg)
$K -n $NS get pod -o wide

probe() {
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

echo "== $(date -u +%T) 4a: sg-db allows sg-pod only"
probe "$WITH" "4a with-sg"

echo "== add sg-db rule: 8080 from node SG $NODE_SG"
RULE_ID=$(aws ec2 authorize-security-group-ingress ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" --group-id "$DB_SG" \
  --ip-permissions "IpProtocol=tcp,FromPort=8080,ToPort=8080,UserIdGroupPairs=[{GroupId=$NODE_SG,Description=test4-node-sg}]" \
  --query 'SecurityGroupRules[0].SecurityGroupRuleId' --output text)
trap 'aws ec2 revoke-security-group-ingress ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" --group-id "$DB_SG" --security-group-rule-ids "$RULE_ID" > /dev/null && echo "removed $RULE_ID"' EXIT
sleep 15
echo "== $(date -u +%T) 4b: sg-db also allows node SG"
probe "$WITH" "4b with-sg"
probe "$NOSG" "4b no-sg"

echo "== VPC B flow logs, dstport 8080 (wait 90s for delivery)"
sleep 90
echo "interface-id srcaddr dstaddr srcport dstport protocol action direction"
aws logs filter-log-events ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" --log-group-name "$LOG_GROUP" \
  --start-time "$START_MS" --filter-pattern '[iface, src, dst, sport, dport=8080, ...]' \
  --query 'events[].message' --output text | tr '\t' '\n'
echo "pod IPs: with-sg=$($K -n $NS get pod "$WITH" -o jsonpath='{.status.podIP}') no-sg=$($K -n $NS get pod "$NOSG" -o jsonpath='{.status.podIP}') node=$($K get node -o jsonpath='{.items[0].status.addresses[0].address}')"
echo "saved: $RESULT"
