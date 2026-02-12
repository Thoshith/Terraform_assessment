terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  project_name         = var.project_name
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  environment  = var.environment
  project_name = var.project_name
}

# Compute Module
module "compute" {
  source = "./modules/compute"

  environment          = var.environment
  project_name         = var.project_name
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  instance_type        = var.instance_type
  iam_instance_profile = module.iam.ec2_instance_profile_name
  key_name             = var.key_name
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  environment  = var.environment
  project_name = var.project_name
  bucket_name  = var.log_bucket_name
}
