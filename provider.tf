terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 1.0"
    }
  }
}
provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}


