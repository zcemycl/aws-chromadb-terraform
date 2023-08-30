variable "name" {
  type    = string
  default = ""
}

variable "subnets_cidr" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_map_public_ip_on_launch" {
  type    = bool
  default = false
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "include_public_route_table" {
  type    = bool
  default = false
}

variable "include_private_route_table" {
  type    = bool
  default = false
}

variable "map_subnet_to_public_route_tables" {
  default = []
}

variable "map_subnet_to_private_route_tables" {
  default = []
}
