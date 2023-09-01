resource "aws_api_gateway_vpc_link" "chroma_api" {
  name        = "chroma_gateway_vpclink"
  description = "Chroma Instance VPC Link. Managed by Terraform."
  target_arns = [aws_lb.lb.arn]
}

resource "aws_api_gateway_rest_api" "chroma_api" {
  name        = "chroma-api"
  description = "chroma api endpoint"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "chroma_api" {
  rest_api_id = aws_api_gateway_rest_api.chroma_api.id
  parent_id   = aws_api_gateway_rest_api.chroma_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "chroma_api" {
  rest_api_id      = aws_api_gateway_rest_api.chroma_api.id
  resource_id      = aws_api_gateway_resource.chroma_api.id
  http_method      = "ANY"
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "chroma_api" {
  rest_api_id             = aws_api_gateway_rest_api.chroma_api.id
  resource_id             = aws_api_gateway_resource.chroma_api.id
  http_method             = aws_api_gateway_method.chroma_api.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${aws_lb.lb.dns_name}:8000/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.chroma_api.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "chroma_api" {
  depends_on = [
    aws_api_gateway_integration.chroma_api
  ]
  rest_api_id = aws_api_gateway_rest_api.chroma_api.id
  stage_name  = "dev"
  triggers = {
    redeployment = sha1(jsonencode(
      [
        aws_api_gateway_resource.chroma_api,
        aws_api_gateway_method.chroma_api
      ]
    ))
  }
  lifecycle {
    create_before_destroy = true
  }
}
