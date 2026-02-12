# AL2023 ami
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = var.iam_instance_profile
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-cloudwatch-agent

              # Configure CloudWatch agent
              cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<'EOC'
              {
                "logs": {
                  "logs_collected": {
                    "files": {
                      "collect_list": [
                        {
                          "file_path": "/var/log/messages",
                          "log_group_name": "/aws/ec2/${var.environment}",
                          "log_stream_name": "{instance_id}"
                        }
                      ]
                    }
                  }
                }
              }
              EOC

              # Start CloudWatch agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -s \
                -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json

              echo "Instance initialized successfully" > /var/log/init-complete.log
              EOF

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name        = "${var.project_name}-${var.environment}-root-volume"
      Environment = var.environment
      Project     = var.project_name
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-app-server"
    Environment = var.environment
    Project     = var.project_name
  }

  lifecycle {
    create_before_destroy = true
  }
}
