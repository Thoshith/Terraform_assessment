Question: How do you handle infrastructure drift? 


Answer: Detect drift using terraform plan and terraform refresh regularly. Resolve by either updating Terraform code to match infrastructure changes or running terraform apply to revert infrastructure to desired state. Prevent drift through IAM restrictions, lifecycle rules (prevent_destroy, ignore_changes) and automated drift detection in CI/CD pipelines.

Question: How would you import an existing VPC into Terraform? 


Answer: First, write the Terraform resource block matching the VPC configuration. Use terraform import aws_vpc.existing_vpc vpc-123xxxxxxxx to import the resource into state. Run terraform plan to identify any differences and update the configuration accordingly. Import related resources like subnets, route tables and internet gateways separately.

Question: How do you prevent accidental deletion of production infrastructure? 


Answer: Use lifecycle prevent_destroy rules on critical resources, enable state locking with remote backends (S3 + DynamoDB), implement IAM access controls and require manual approval for production deployments. Separate workspaces for environments, use resource tagging, maintain state file backups.
