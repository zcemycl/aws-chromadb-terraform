resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "cloud_pem" {
  filename = "ssh-chroma.pem"
  content  = tls_private_key.ssh_key.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 ssh-chroma.pem"
  }
}

resource "aws_vpc" "base_vpc" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

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
