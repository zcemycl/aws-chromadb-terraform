output "chroma_log_group" {
  value = aws_cloudwatch_log_group.logging["chroma"].name
}

output "log_groups" {
  value = aws_cloudwatch_log_group.logging
}

output "log_streams" {
  value = aws_cloudwatch_log_stream.logging
}
