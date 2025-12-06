#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."/terraform
terraform init -input=false
terraform apply -auto-approve
