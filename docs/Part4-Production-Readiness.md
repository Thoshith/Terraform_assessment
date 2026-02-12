Question: Explain how Terraform fits into CI/CD?


Answer: Terraform integrates into CI/CD by running terraform plan automatically on every pull request so the team can review infrastructure changes before merging. Once the PR is approved and merged to the main branch, terraform apply runs automatically to deploy the changes. This ensures all infrastructure changes go through version control, code review, and approval before reaching production. Tools like GitHub Actions, GitLab CI, or Jenkins are commonly used to set up this pipeline. This approach eliminates manual apply from local machines and provides a consistent, auditable deployment process.

Question: Describe your secrets-management approach? 


Answer: Never hardcode secrets in Terraform code. Use AWS Secrets Manager or HashiCorp Vault to retrieve secrets dynamically using data sources. Prefer IAM roles over access keys, use environment variables for provider credentials, and encrypt state files. Implement secrets rotation, least privilege access, and separate secrets per environment with audit logging.

Question: Explain version pinning and upgrade strategy? 


Answer: Pin Terraform version using required_version = "~> 1.14.0" and provider versions using required_providers block with version constraints. Use pessimistic constraints (~>) to allow patch updates while preventing breaking changes. Test upgrades in development first, review changelogs, use .terraform.lock.hcl for dependency locking, and follow staged rollout (Dev → Staging → Production) with thorough validation at each stage.
