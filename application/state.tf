terraform {
  backend "s3" {
    bucket = "let-code-speak-for-itself.ap-southeast-2.terraform"
    key    = "application"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0" 
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}