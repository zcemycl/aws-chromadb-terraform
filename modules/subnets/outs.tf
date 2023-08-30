output "igw_group" {
  value = aws_internet_gateway.igw
}

output "public_route_tables" {
  value = aws_route_table.public_route_table
}

output "private_route_tables" {
  value = aws_route_table.private_route_table
}

output "subnet_ids" {
  value = aws_subnet.subnets[*].id
}
