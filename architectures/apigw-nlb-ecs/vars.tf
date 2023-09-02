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

variable "public_subnets_cidr" {
  default = ["10.1.0.0/21"]
}

variable "chroma_subnets_cidr" {
  default = ["10.1.16.0/21"]
}

variable "availability_zones" {
  default = ["eu-west-2a"]
}

variable "fargate_ephemeral_storage_size" {
  default = 24
}
