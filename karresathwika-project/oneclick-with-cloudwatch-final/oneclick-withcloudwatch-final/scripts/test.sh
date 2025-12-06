#!/bin/bash
set -euo pipefail
if [ -z "${1:-}" ]; then
  echo "Usage: $0 <ALB-DNS>"
  exit 1
fi
ALB="$1"
echo "Testing /health"
curl -sv "http://${ALB}/health" || true
echo
echo "Testing /"
curl -sv "http://${ALB}/" || true
echo
