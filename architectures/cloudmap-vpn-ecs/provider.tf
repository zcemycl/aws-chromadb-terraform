# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "acm_eu"
  region = "eu-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.24"
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.11.1"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "3.2.4"
    }
  }
}
