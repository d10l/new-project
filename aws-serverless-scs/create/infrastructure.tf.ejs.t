---
to: infrastructure.tf
---
provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region     = "${var.AWS_REGION}"
}

data "template_file" "openapi_spec" {
  template = "${file("${path.module}/openapi.yaml")}"
  vars = {
    #consul_address = "${aws_instance.consul.private_ip}"
  }
}

module "lambdas" {
  source = "./<%= functionname %>"
}

resource "aws_api_gateway_rest_api" "<%= servicename %>" {
  name        = "<%= servicename %>"
  description = "Terraform Serverless Application Example"

  body = "${data.template_file.openapi_spec.rendered}"
}

resource "aws_api_gateway_deployment" "<%= servicename %>" {
  rest_api_id = "${aws_api_gateway_rest_api.<%= servicename %>.id}"
  stage_name  = "dev"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambdas.aws_lambda_function_<%= functionname %>_arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.<%= servicename %>.execution_arn}/*/*"
}

# db
resource "aws_dynamodb_table" "<%= servicename %>" {
  name         = "TenantManagement"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "TenantId"

  attribute {
    name = "TenantId"
    type = "S"
  }
}

output "base_url" {
  value = "${aws_api_gateway_deployment.<%= servicename %>.invoke_url}"
}
