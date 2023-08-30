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

variable "Region2AMI" {
  default = {
    "eu-west-2"      = "ami-0a6006bac3b9bb8d3"
    "ap-south-1"     = "ami-0d81306eddc614a45"
    "eu-north-1"     = "ami-053482eb0c86d0d7c"
    "eu-west-3"      = "ami-09397266f6e315988"
    "eu-west-1"      = "ami-061c44bfbae6a80bf"
    "ap-northeast-3" = "ami-0c66c8e259df7ec04"
    "ap-northeast-2" = "ami-0f6e451b865011317"
    "ap-northeast-1" = "ami-0bba69335379e17f8"
    "ca-central-1"   = "ami-000a431453ec36291"
    "sa-east-1"      = "ami-0a9e90bd830396d02"
    "ap-southeast-1" = "ami-0f13a1efb26061f67"
    "ap-southeast-2" = "ami-0d6294dcaac5546e4"
    "eu-central-1"   = "ami-0f61af304b14f15fb"
    "us-east-1"      = "ami-09988af04120b3591"
    "us-east-2"      = "ami-0533def491c57d991"
    "us-west-1"      = "ami-0b695b365bec60938"
    "us-west-2"      = "ami-00ee4df451840fa9d"
  }
}
