provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
  assume_role {
    role_arn    = var.assume_role.role_arn
    external_id = var.assume_role.external_id
  }
}

terraform {
  backend "s3" {
    bucket         = "nsse-terraform-state-bucket-site-AWSAccount"
    key            = "site/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "nsse-terraform-state-lock-table"
  }
}
