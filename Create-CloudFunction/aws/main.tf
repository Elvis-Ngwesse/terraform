# -----------------------------
# Env variables
# -----------------------------
locals {
  environment = var.environment  # Set the environment variable from the user input
}

# -----------------------------
# Provider Configuration
# -----------------------------
provider "aws" {
  region = var.aws_region  # Specify the AWS region to deploy resources
}

# -----------------------------
# Generate a random string for the S3 bucket name
# -----------------------------
resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

# -----------------------------
# Create an S3 bucket to store the Lambda code
# -----------------------------
resource "aws_s3_bucket" "function_bucket" {
  bucket = "${var.bucket_name_prefix}-${random_string.bucket_name.result}"

  tags = {
    Name = var.bucket_name_tag
    Env  = var.environment
  }
}

# -----------------------------
# Upload your Lambda function ZIP
# -----------------------------
resource "aws_s3_object" "function_zip" {
  bucket = aws_s3_bucket.function_bucket.bucket
  key    = var.function_zip_file
  source = var.function_zip_file
  etag   = filemd5(var.function_zip_file)
}

# -----------------------------
# Upload the Flask + awsgi Lambda Layer ZIP
# -----------------------------
resource "aws_s3_object" "flask_layer_zip" {
  bucket = aws_s3_bucket.function_bucket.bucket
  key    = var.flask_layer_zip_file
  source = var.flask_layer_zip_file
  etag   = filemd5(var.flask_layer_zip_file)
}

# -----------------------------
# Create the Lambda Layer
# -----------------------------
resource "aws_lambda_layer_version" "flask_layer" {
  layer_name          = "flask"
  compatible_runtimes = ["python3.10"]  # Adjust to match var.lambda_runtime
  s3_bucket           = aws_s3_bucket.function_bucket.bucket
  s3_key              = aws_s3_object.flask_layer_zip.key
  source_code_hash    = filebase64sha256(var.flask_layer_zip_file)
}

# -----------------------------
# IAM role for Lambda
# -----------------------------
resource "aws_iam_role" "lambda_exec_role" {
  name = var.lambda_exec_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

# -----------------------------
# IAM policy attachment for Lambda basic execution
# -----------------------------
resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -----------------------------
# Lambda function
# -----------------------------
resource "aws_lambda_function" "put_function" {
  function_name = "put_api_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  s3_bucket     = aws_s3_bucket.function_bucket.bucket
  s3_key        = aws_s3_object.function_zip.key

  layers = [
    aws_lambda_layer_version.flask_layer.arn
  ]

  environment {
    variables = {
      ENV = var.environment
    }
  }
}

# -----------------------------
# Create an API Gateway to trigger the Lambda
# -----------------------------
resource "aws_apigatewayv2_api" "http_api" {
  name          = "http-api"
  protocol_type = "HTTP"
}

# -----------------------------
# Lambda integration with API Gateway
# -----------------------------
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                = aws_apigatewayv2_api.http_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.put_function.invoke_arn
  integration_method    = "POST"
  payload_format_version = "2.0"
}

# -----------------------------
# Create a route
# -----------------------------
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "PUT /"  # Matches your PUT trigger
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# -----------------------------
# Create a stage
# -----------------------------
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# -----------------------------
# Give permission for API Gateway to invoke Lambda
# -----------------------------
resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# -----------------------------
# Output the API Gateway URL
# -----------------------------
output "function_url" {
  value       = aws_apigatewayv2_api.http_api.api_endpoint
  description = "Invoke URL of the Lambda function via API Gateway"
}
