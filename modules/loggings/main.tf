resource "aws_cloudwatch_log_group" "logging" {
  for_each = {
    for log in var.loggings : log.name => log
  }
  name              = each.value.group_name
  retention_in_days = each.value.retention_in_days
}

resource "aws_cloudwatch_log_stream" "logging" {
  for_each = {
    for log in var.loggings : log.name => log
  }
  name           = each.value.stream_name
  log_group_name = aws_cloudwatch_log_group.logging[each.value.name].name
}
