#!/usr/bin/env bash
# SSM port forwarding to the private EKS API through the node; writes the
# kubeconfig context sgref-tunnel (https://127.0.0.1:$PORT). Foreground, Ctrl-C ends it.
set -Eeuo pipefail
cd "$(dirname "$0")"
# Credentials come from the environment: --profile is passed only when AWS_PROFILE is set.
REGION=${AWS_REGION:-ap-northeast-2}
PORT=${PORT:-8445}
CLUSTER=$(terraform output -raw cluster_name)

NODE=$(aws ec2 describe-instances ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" \
  --filters "Name=tag:eks:cluster-name,Values=$CLUSTER" "Name=instance-state-name,Values=running" \
  --query 'Reservations[0].Instances[0].InstanceId' --output text)
[[ "$NODE" == i-* ]] || { echo "no running node for $CLUSTER" >&2; exit 1; }
read -r HOST CA < <(aws eks describe-cluster ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" --name "$CLUSTER" \
  --query '[cluster.endpoint, cluster.certificateAuthority.data]' --output text)
HOST=${HOST#https://}

CTX=sgref-tunnel
kubectl config set-cluster "$CTX" --server="https://127.0.0.1:$PORT" --tls-server-name="$HOST" > /dev/null
kubectl config set "clusters.$CTX.certificate-authority-data" "$CA" > /dev/null
kubectl config set-credentials "$CTX" --exec-api-version=client.authentication.k8s.io/v1beta1 --exec-command=aws \
  --exec-arg=eks --exec-arg=get-token --exec-arg=--cluster-name --exec-arg="$CLUSTER" \
  --exec-arg=--region --exec-arg="$REGION" ${AWS_PROFILE:+--exec-arg=--profile --exec-arg="$AWS_PROFILE"} > /dev/null
kubectl config set-context "$CTX" --cluster="$CTX" --user="$CTX" > /dev/null

echo "TUNNEL $CLUSTER via $NODE on 127.0.0.1:$PORT (context $CTX)"
exec aws ssm start-session ${AWS_PROFILE:+--profile "$AWS_PROFILE"} --region "$REGION" --target "$NODE" \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters "host=$HOST,portNumber=443,localPortNumber=$PORT"
