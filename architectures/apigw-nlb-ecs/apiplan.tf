resource "aws_api_gateway_usage_plan" "api_key" {
  name = "api_key_usage_plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.chroma_api.id
    stage  = aws_api_gateway_deployment.chroma_api.stage_name
  }
  quota_settings {
    limit  = 100000
    period = "MONTH"
  }
  throttle_settings {
    burst_limit = 500
    rate_limit  = 10
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "chroma-api-key"
  provisioner "local-exec" {
    command = "echo ${aws_api_gateway_api_key.api_key.value} >> info.txt"
  }
}

resource "aws_api_gateway_usage_plan_key" "api_key" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.api_key.id
}
