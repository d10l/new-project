---
to: <%= servicename %>/infrastructure.tf
---
provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "${var.AWS_REGION}"
}

module "tenant_lambda" {
  source = "./<%= servicename %>"
}

resource "aws_api_gateway_rest_api" "tenant_mangement" {
  name        = "tenant_management"
  description = "Terraform Serverless Application Example"

  body = "${data.template_file.api_gateway_openapi_spec.rendered}"
}

resource "aws_api_gateway_deployment" "tenant_management" {
  rest_api_id = "${aws_api_gateway_rest_api.main.id}"
  stage_name  = "dev"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.example.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"
}

# db
resource "aws_dynamodb_table" "tenant_mangement" {
  name         = "TenantManagement"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "TenantId"

  attribute {
    name = "TenantId"
    type = "S"
  }
}

output "base_url" {
  value = "${aws_api_gateway_deployment.example.invoke_url}"
}
