provider "aws" {
  region = "eu-west-2"  # London region (similar to GCP europe-west2)
}

# Generate a random string for the S3 bucket name
resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

# Create an S3 bucket to store the Lambda code
resource "aws_s3_bucket" "function_bucket" {
  bucket = "bucket-${random_string.bucket_name.result}"

  tags = {
    Name = "lambda-function-bucket"
    Env  = "production"
  }
}

# Upload your Lambda function ZIP
resource "aws_s3_bucket_object" "function_zip" {
  bucket = aws_s3_bucket.function_bucket.id
  key    = "function.zip"
  source = "function.zip"
  etag   = filemd5("function.zip")
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

# IAM policy attachment for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_exec_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "put_function" {
  function_name = "put_api_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "main.update_data"
  runtime       = "python3.10"
  s3_bucket     = aws_s3_bucket.function_bucket.id
  s3_key        = aws_s3_bucket_object.function_zip.key

  environment {
    variables = {
      ENV = "production"
    }
  }
}

# Create an API Gateway to trigger the Lambda
resource "aws_apigatewayv2_api" "http_api" {
  name          = "http-api"
  protocol_type = "HTTP"
}

# Lambda integration with API Gateway
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.put_function.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

# Create a route
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "PUT /"  # Matches your PUT trigger
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Create a stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Give permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.put_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Output the API Gateway URL
output "function_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
  description = "Invoke URL of the Lambda function via API Gateway"
}
