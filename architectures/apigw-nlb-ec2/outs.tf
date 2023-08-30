output "chroma_private_ip" {
  value = aws_instance.chroma_instance.private_ip
}

output "backdoor_public_ip" {
  value = aws_instance.backdoor_instance.public_ip
}
