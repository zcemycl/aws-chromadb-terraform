output "chroma_log_group" {
  value = aws_cloudwatch_log_group.logging["chroma"].name
}
