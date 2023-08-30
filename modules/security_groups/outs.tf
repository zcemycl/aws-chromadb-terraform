output "chroma_instance_sg_id" {
  value = aws_security_group.sg["ec2-chroma"].id
}
