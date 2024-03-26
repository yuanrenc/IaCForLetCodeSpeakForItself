terraform {
  backend "s3" {
    bucket = "let-code-speak-for-itself.ap-southeast-2.terraform"
    key    = "database"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}