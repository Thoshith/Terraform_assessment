Question: Explain how Terraform fits into CI/CD Terraform integrates into CI/CD? 
Answer: By running terraform validate and terraform plan on pull requests, storing plans as artifacts, and executing terraform apply on merge to main branch. Use automated testing, security scanning (tfsec, checkov), and manual approval gates for production. Implement environment promotion (Dev → Staging → Production) with separate state files or workspaces per environment.

Question: Describe your secrets-management approach Never hardcode secrets in Terraform code? 
Answer: Use AWS Secrets Manager or HashiCorp Vault to retrieve secrets dynamically using data sources. Prefer IAM roles over access keys, use environment variables for provider credentials, and encrypt state files. Implement secrets rotation, least privilege access, and separate secrets per environment with audit logging.

Question: Explain version pinning and upgrade strategy? 
Answer: Pin Terraform version using required_version = "~> 1.14.0" and provider versions using required_providers block with version constraints. Use pessimistic constraints (~>) to allow patch updates while preventing breaking changes. Test upgrades in development first, review changelogs, use .terraform.lock.hcl for dependency locking, and follow staged rollout (Dev → Staging → Production) with thorough validation at each stage.
