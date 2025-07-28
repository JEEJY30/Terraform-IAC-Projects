terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  # backend "s3" {
  #   bucket         = "terraform00012223232nv"  # Replace with your bucket
  #   key            = "identity-center/terraform.tfstate"
  #   region         = "us-east-1"                         # Replace with your region
  #   encrypt        = true
  #   # dynamodb_table = "terraform-state-lock"            # Optional: for state locking
  # }
}

provider "aws" {
  region = var.aws_region
  profile = "management"

  default_tags {
    tags = {
      Project     = "identity-center"
      ManagedBy   = "terraform"
      Environment = var.environment
    }
  }
}