resource "aws_lambda_function" "sync_cognito_with_azuread" {
  filename      = "${path.module}/lambda/zipped/sync_cognito_with_azuread.zip"
  function_name = "sync-cognito-with-azuread"
  role          = aws_iam_role.sync_lambda_role.arn
  handler       = "sync.handler"
  runtime       = var.sync_lambda_runtime
  architectures = [var.sync_lambda_architecture]

  # Environment variables for Azure AD and Cognito
  environment {
    variables = {
      AZURE_TENANT_ID      = var.azure_tenant_id
      AZURE_CLIENT_ID      = var.azure_client_id
      AZURE_CLIENT_SECRET  = var.azure_client_secret
      COGNITO_USER_POOL_ID = var.cognito_user_pool_id
    }
  }
}

resource "aws_iam_role" "sync_lambda_role" {
  name = "sync-cognito-azuread-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sync_lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sync_lambda_role.name
}

# Optionally, add a CloudWatch Event Rule to trigger the Lambda on a schedule
resource "aws_cloudwatch_event_rule" "sync_schedule" {
  name                = "sync-cognito-azuread-schedule"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "sync_lambda_target" {
  rule      = aws_cloudwatch_event_rule.sync_schedule.name
  target_id = "sync-cognito-azuread-lambda"
  arn       = aws_lambda_function.sync_cognito_with_azuread.arn
}

resource "aws_lambda_permission" "allow_events_to_invoke_sync" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sync_cognito_with_azuread.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sync_schedule.arn
}
