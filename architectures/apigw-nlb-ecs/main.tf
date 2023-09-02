resource "aws_vpc" "base_vpc" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

module "igw_network" {
  source                     = "../../modules/subnets"
  vpc_id                     = aws_vpc.base_vpc.id
  include_public_route_table = true
}


module "public_subnet_network" {
  source                            = "../../modules/subnets"
  name                              = "public-subnet"
  subnets_cidr                      = var.public_subnets_cidr
  vpc_id                            = aws_vpc.base_vpc.id
  subnet_map_public_ip_on_launch    = true
  availability_zones                = var.availability_zones
  include_private_route_table       = true
  map_subnet_to_public_route_tables = module.igw_network.public_route_tables
}

module "chroma_network" {
  source                             = "../../modules/subnets"
  name                               = "chroma"
  subnets_cidr                       = var.chroma_subnets_cidr
  vpc_id                             = aws_vpc.base_vpc.id
  availability_zones                 = var.availability_zones
  map_subnet_to_private_route_tables = module.public_subnet_network.private_route_tables
}
