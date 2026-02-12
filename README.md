# About
This is a production ready AWS infrastructure built with Terraform, featuring modular design, multi-environment support (dev/prod), remote state with S3 + DynamoDB locking, and secure VPC architecture with private EC2 and logging

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

# Architecture Diagram

                               +----------------------+
                               |       Internet       |
                               +----------+-----------+
                                          |
                                          |
                                 +--------v--------+
                                 |  Internet GW    |
                                 +--------+--------+
                                          |
                 -------------------------------------------------
                 |                                               |
        +--------v--------+                             +-------v--------+
        |  Public Subnet  |                             |  Public Subnet |
        |      (AZ-1)     |                             |     (AZ-2)     |
        +--------+--------+                             +-------+--------+
                 |                                               |
                 |        Public Route Table (IGW Route)         |
                 |                                               |
        -------------------------------------------------------------------
                 |                                               |
        +--------v--------+                             +-------v--------+
        | Private Subnet  |                             | Private Subnet |
        |      (AZ-1)     |                             |     (AZ-2)     |
        +--------+--------+                             +-------+--------+
                 |
                 |
          +------v-------+
          |  EC2 Instance|
          |  (Private)   |
          |  IAM Role    |
          |  User Data   |
          +------+-------+
                 |
                 |
          +------v-------+
          |   S3 Bucket  |
          | Application   |
          |     Logs      |
          | (Encrypted &  |
          |  Versioned)   |
          +--------------+

# Remote Backend

```
+---------------------------+
|   Terraform (CLI/User)    |
+-------------+-------------+
              |
              |
      +-------v--------+
      |   S3 Bucket    |
      | Terraform State|
      |  (Versioned)   |
      +-------+--------+
              |
              |
      +-------v--------+
      | DynamoDB Table |
      |  State Locking |
      +----------------+
```


## Prerequisites

| Requirement         | Details                          |
|---------------------|----------------------------------|
| Terraform           | >= 1.14.0                         |
| AWS CLI             | Configured with valid credentials|
| AWS Account         | With sufficient IAM permissions  |
| S3 Bucket           | For remote state backend         |
| DynamoDB Table      | For state locking                |

### Create Backend Resources (one-time setup)
Create S3 bucket and DynamoDB table for remote state backend. Enable versioning for the S3 bucket. 
Note: Update backend.tf with your actual bucket name and region

### Design Choices

Networking (VPC Module)

    CIDR 10.0.0.0/16
    2 public + 2 private subnets spread across 2 AZs for high availability
    Internet Gateway attached to public subnets via route tables
    Private subnets have no direct internet access.
    NAT Gateway can be added if private instances need outbound access

Compute (Compute Module)

    EC2 instance placed in a private subnet (not publicly accessible)
    IAM instance profile attached
    User data script for bootstrapping at launch
    Security group allows only necessary traffic

Storage (Storage Module)

    S3 bucket for application logs
    Versioning enabled to prevent accidental data loss
    Server-side encryption (SSE-S3) enabled by default
    Public access blocked at bucket level

IAM (IAM Module)

    Dedicated IAM role for EC2 with least privilege
    Instance profile attached — no access keys needed
    S3 write permissions scoped to the specific log bucket only

Tagging Strategy

Every resource is tagged consistently:

```
tags = {
  Environment = var.environment
  Project     = var.project_name
  ManagedBy   = "Terraform"
  Owner       = "Thoshith"
}
```

Multi-Environment Support

    dev.tfvars — smaller instances, minimal resources
    prod.tfvars — larger instances, production-grade settings
    Same codebase, different configurations

Remote Backend

    S3 for state storage with versioning
    DynamoDB for state locking (prevents concurrent modifications)
    Separate state per environment using key path


### Assumptions
	
1: AWS CLI is pre-configured with appropriate credentials

2: S3 backend bucket and DynamoDB table are created before terraform init

3: Region used is us-east-1 — configurable via variables

4: EC2 instance does not need outbound internet (no NAT Gateway provisioned)

5: Default VPC and subnets are not used — everything is custom

6: A single EC2 instance is sufficient for this assessment

7: Application logs are written directly to S3

8: SSH access to EC2 is not configured (private subnet, no bastion)



### Trade-offs

1: No NAT Gateway provisioned — saves cost but private instances cannot reach the internet

2: No bastion host — reduces attack surface but no direct SSH access to private EC2

3: Single EC2 instance without ASG — keeps it simple but no auto-scaling or self-healing

4: S3 used for logs instead of CloudWatch — cost effective but no real-time monitoring or alerting

5: No VPC endpoints configured — less complexity but S3 traffic routes over the internet path

6: No multi-region setup — simpler architecture

7: smaller instance used in dev — free tier eligible but limited compute power for heavy workloads

## Quick Reference

### Initialize
terraform init

### Format code
terraform fmt -recursive

### Validate syntax
terraform validate

### Plan for dev
terraform plan -var-file="dev.tfvars"

### Apply for dev
terraform apply -var-file="dev.tfvars"

### Plan for Prod
terraform plan -var-file="prod.tfvars"

### Apply for Prod
terraform apply -var-file="prod.tfvars"

### Destroy dev
terraform destroy -var-file="dev.tfvars"

## Reference from Terraform Docs

VPC Module

1: VPC — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

2: Subnet — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

3: Internet Gateway — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

4: Route Table — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

5: Route Table Association — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

Compute Module

6: EC2 Instance — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

7: Security Group — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

Storage Module

8: S3 Bucket — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

9: S3 Bucket Versioning — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning

10: S3 Bucket Encryption — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration

11: S3 Public Access Block — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block

IAM Module

12: IAM Role — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

13: IAM Policy — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy

14: IAM Role Policy Attachment — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

15: IAM Instance Profile — https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile

Backend

16: S3 Backend Config — https://developer.hashicorp.com/terraform/language/settings/backends/s3
