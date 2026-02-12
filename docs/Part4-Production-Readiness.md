Question: Explain how Terraform fits into CI/CD?


Answer: Terraform integrates into CI/CD by running terraform plan automatically on every pull request so the team can review infrastructure changes before merging. Once the PR is approved and merged to the main branch, terraform apply runs automatically to deploy the changes. This ensures all infrastructure changes go through version control, code review, and approval before reaching production. Tools like GitHub Actions, GitLab CI, or Jenkins are commonly used to set up this pipeline. This approach eliminates manual apply from local machines and provides a consistent, auditable deployment process.

Question: Describe your secrets-management approach? 


Answer: Never hardcode secrets in Terraform code. Use AWS Secrets Manager or HashiCorp Vault to retrieve secrets dynamically using data sources. Prefer IAM roles over access keys, use environment variables for provider credentials, and encrypt state files. Implement secrets rotation, least privilege access, and separate secrets per environment with audit logging.

Question: Explain version pinning and upgrade strategy? 


Answer: Version pinning means locking Terraform and provider versions in required_providers block to ensure consistent behavior across environments and team members. Without pinning, a newer provider version could introduce breaking changes unexpectedly. The upgrade strategy is to bump versions in dev first, run terraform plan to catch issues, test, and then promote to prod. The .terraform.lock.hcl file should be committed to Git so everyone uses the same versions.
