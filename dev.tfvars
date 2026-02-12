environment          = "dev"
aws_region           = "us-east-1"
project_name         = "terraform-assessment"
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
instance_type        = "t3.micro"
log_bucket_name      = "app-logs-dev-25081996"

common_tags = {
  Environment = "dev"
  Project     = "terraform-assessment"
  ManagedBy   = "Terraform"
  Owner       = "Thoshith"
}
