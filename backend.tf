terraform {
  backend "s3" {
    bucket         = "terrafrom-state-bucket-25081996"
    key            = "terraform-assessment/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terrafrom-state-lock"
  }
}
