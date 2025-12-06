
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

# Snapshots of assignment run and output
## VPC with 2 public and 2 private subnets
 <img width="624" height="305" alt="image" src="https://github.com/user-attachments/assets/5a4a01b4-7baf-405e-9d52-e2e480ad7924" />

## Internet Gateway (IGW)
 <img width="624" height="119" alt="image" src="https://github.com/user-attachments/assets/7ac6709f-7771-4e08-ab69-b4c2977631b4" />

## NAT Gateway (in a public subnet)
 <img width="624" height="208" alt="image" src="https://github.com/user-attachments/assets/f02fa585-e65b-4829-9a00-7a50d829a0f5" />

## ALB with HTTP/HTTPS listener 
 <img width="624" height="253" alt="image" src="https://github.com/user-attachments/assets/928cbe62-a009-4b13-97ba-3563342005c2" />

## Target Group (health check: /health or /)
 <img width="624" height="281" alt="image" src="https://github.com/user-attachments/assets/608e6fc6-d6be-4789-aaca-41fc4d291495" />

## Launch template for EC2 instances 
 <img width="624" height="205" alt="image" src="https://github.com/user-attachments/assets/ebf7a295-8bdb-431a-8e1b-9d43d71138a4" />

## Auto Scaling Group (private subnets)
 <img width="624" height="267" alt="image" src="https://github.com/user-attachments/assets/b1b429e5-d8fa-4a19-9ac5-31802697643c" />

## Security Groups:
 <img width="624" height="96" alt="image" src="https://github.com/user-attachments/assets/375db855-9b21-47da-9211-d4241299562a" />

## ALB SG: allow HTTP/HTTPS from internet
 <img width="624" height="214" alt="image" src="https://github.com/user-attachments/assets/1594fda0-7045-419c-82f5-d0ed875eea14" />


## EC2 SG: allow traffic only from ALB SG
 <img width="624" height="187" alt="image" src="https://github.com/user-attachments/assets/d6e46545-d76c-4a58-af3e-bba70abd605b" />

## IAM role for EC2:
 <img width="624" height="255" alt="image" src="https://github.com/user-attachments/assets/f7ba2e27-a217-4ba7-ba61-62fe7606f968" />

## CloudWatch Logs
 <img width="624" height="237" alt="image" src="https://github.com/user-attachments/assets/9fb9edc5-40d2-4a06-84bb-8dc8c212b978" />

## SSM
 <img width="624" height="261" alt="image" src="https://github.com/user-attachments/assets/0d1b16eb-d283-48ad-8828-dbcfacd33d08" />


## API Test
 <img width="624" height="117" alt="image" src="https://github.com/user-attachments/assets/6e55f4e6-27ff-4530-96a8-4be6ca8cba4b" />
 <img width="624" height="113" alt="image" src="https://github.com/user-attachments/assets/5b68c2f3-04ce-4731-9faf-f81688b6a316" />


 



