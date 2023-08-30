resource "aws_subnet" "subnets" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = var.vpc_id
  cidr_block              = element(var.subnets_cidr, count.index)
  map_public_ip_on_launch = var.subnet_map_public_ip_on_launch
  availability_zone       = element(var.availability_zones, count.index)

  tags = {
    Name = "${var.name}-subnet"
  }
}

# public route table
resource "aws_internet_gateway" "igw" {
  count  = var.include_public_route_table ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_route_table" {
  count  = var.include_public_route_table ? 1 : 0
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
}

# private route table
resource "aws_eip" "nat_gateway" {
  count = var.include_private_route_table ? length(var.subnets_cidr) : 0
  vpc   = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.include_private_route_table ? length(var.subnets_cidr) : 0
  allocation_id = element(aws_eip.nat_gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.subnets.*.id, count.index)

  tags = {
    Name = "${var.name}-nat-gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = var.include_private_route_table ? length(var.subnets_cidr) : 0
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
  }

  tags = {
    Name = "${var.name}-private-route-table"
  }
}

# public route table association
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.map_subnet_to_public_route_tables) > 0 ? length(aws_subnet.subnets) : 0
  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = var.map_subnet_to_public_route_tables[0].id
}

# private route table association
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.map_subnet_to_private_route_tables) > 0 ? length(aws_subnet.subnets) : 0
  subnet_id      = element(aws_subnet.subnets.*.id, count.index)
  route_table_id = element(var.map_subnet_to_private_route_tables.*.id, count.index)
}
