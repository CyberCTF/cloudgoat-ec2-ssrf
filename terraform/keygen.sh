#!/bin/sh
# The lab's SSH key pair, made once (CloudGoat's CLI runs the same ssh-keygen), and where it is, in
# the JSON Terraform's `external` data source reads. Usage: keygen.sh <folder>
set -eu
dir=$1
mkdir -p "$dir"
[ -f "$dir/cloudgoat" ] || ssh-keygen -b 4096 -t rsa -f "$dir/cloudgoat" -q -N "" -C cloudgoat >/dev/null
printf '{"public":"%s","private":"%s"}\n' "$dir/cloudgoat.pub" "$dir/cloudgoat"
