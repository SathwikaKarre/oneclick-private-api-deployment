
# One-Click ALB → ASG → Private EC2 Assignment

This repository contains a production-oriented, one-click Terraform deployment that provisions:
- VPC (2 public + 2 private subnets)
- Internet Gateway, NAT Gateway
- Application Load Balancer (public)
- Target Group + health checks
- Launch Template + Auto Scaling Group (private subnets)
- EC2 IAM role with SSM and CloudWatch permissions
- Simple Node.js app (port 8080) installed via user-data

## Prerequisites
- AWS account with credentials configured (`aws configure`)
- Terraform 1.0+
- AWS CLI (optional for manual checks)
- Region default: ap-south-1 (you can change in terraform/variables.tf)

## Deployment (one-click)
From repository root:
```bash
./scripts/deploy.sh
```
This runs `terraform init` and `terraform apply -auto-approve`. On success, Terraform will print an output `alb_dns_name`.

## Testing
After deploy, get ALB DNS from Terraform output, or run:
```bash
cd terraform
terraform output alb_dns_name
```
Then test:
```bash
./scripts/test.sh <ALB-DNS>
```
Expected:
- `/health` → `ok`
- `/` → `Hello from private EC2!`

## Teardown
To avoid AWS charges:
```bash
./scripts/destroy.sh
```
This runs `terraform destroy -auto-approve`.

## GitHub Actions (optional)
Workflow file: `.github/workflows/deploy.yml`
It is configured for manual `workflow_dispatch` runs and expects GitHub secrets:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION (optional, default ap-south-1)

## Notes & Security
- EC2 instances have **no public IP** and access internet only via NAT.
- Do not hardcode secrets. Use SSM Parameters or Secrets Manager in future iterations.
- SSH is not opened; use SSM Session Manager to connect if needed.

