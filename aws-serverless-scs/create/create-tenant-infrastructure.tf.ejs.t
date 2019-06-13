---
to: <%= servicename %>/<%= functionname %>/infrastructure.tf
---
resource "aws_lambda_function" "create_tenants" {
  function_name = "ServerlessExample"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "saas-platform-lambda-repository"
  s3_key    = "v1.0.0c/example.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"

  runtime = "nodejs6.10"

  role = "${aws_iam_role.create_tenants.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "create_tenants" {
  name = "create_tenants"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:PutItem"
      ],
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
