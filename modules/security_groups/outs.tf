output "chroma_sg_id" {
  value = aws_security_group.sg["chroma"].id
}

output "security_groups" {
  value = aws_security_group.sg
}
