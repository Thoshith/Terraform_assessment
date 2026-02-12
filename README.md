# About
Production ready AWS infrastructure built with Terraform, featuring modular design, multi-environment support (dev/prod), remote state with S3 + DynamoDB locking, and secure VPC architecture with private EC2 and logging

# Project_Structure
```
terraform-aws-assessment/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── backend.tf
├── dev.tfvars
├── prod.tfvars
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── storage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── iam/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── docs/
    ├── part3-scenarios.md
    └── part4-production.md
```
