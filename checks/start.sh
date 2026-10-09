#!/bin/sh
# The starting user's access key works, and the SSRF web application on EC2 answers.
set -eu
arn=$(env -u AWS_SESSION_TOKEN -u AWS_PROFILE -u AWS_CREDENTIAL_EXPIRATION \
  AWS_ACCESS_KEY_ID="$ISOLOOM_OUTPUT_ACCESS_KEY_ID" AWS_SECRET_ACCESS_KEY="$ISOLOOM_OUTPUT_SECRET_KEY" \
  aws sts get-caller-identity --query Arn --output text)
case "$arn" in */solus-*) ;; *) echo "the key authenticates as $arn" >&2; exit 1 ;; esac
ip=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=cg-ubuntu-ec2-ec2_ssrf_cgid*' \
  Name=instance-state-name,Values=running --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
curl -fsS -m 10 "http://$ip/" | grep -q 'SSRF demo'
