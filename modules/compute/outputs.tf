output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app_server.id
}

output "private_ip" {
  description = "EC2 instance private IP"
  value       = aws_instance.app_server.private_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.ec2_sg.id
}
