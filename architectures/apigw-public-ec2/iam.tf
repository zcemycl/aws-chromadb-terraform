resource "aws_iam_role" "apigw_iam" {
  name               = "apigw_task_role"
  assume_role_policy = file("policies/apigw-task-role.json")
}

resource "aws_iam_role_policy_attachment" "apigw_role_policy" {
  role       = aws_iam_role.apigw_iam.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
