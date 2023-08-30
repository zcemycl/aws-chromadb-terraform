variable "aws_region" {
  default = "eu-west-2"
}

variable "aws_az" {
  default = "eu-west-2a"
}

variable "author" {
  default = "Leo"
}

variable "instance_type" {
  default = "t3.small"
}

variable "Region2AMI" {
  default = {
    "eu-west-2" = "ami-0a6006bac3b9bb8d3"
  }
}
