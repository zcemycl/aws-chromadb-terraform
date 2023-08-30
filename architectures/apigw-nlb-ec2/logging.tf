resource "aws_api_gateway_account" "main" {
  cloudwatch_role_arn = aws_iam_role.apigw_iam.arn
}

resource "aws_api_gateway_method_settings" "general_settings" {
  rest_api_id = aws_api_gateway_rest_api.chroma_api.id
  stage_name  = aws_api_gateway_deployment.chroma_api.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}
