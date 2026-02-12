output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.compute.instance_id
}

output "ec2_private_ip" {
  description = "EC2 instance private IP"
  value       = module.compute.private_ip
}

output "log_bucket_name" {
  description = "S3 log bucket name"
  value       = module.storage.bucket_name
}

output "log_bucket_arn" {
  description = "S3 log bucket ARN"
  value       = module.storage.bucket_arn
}
