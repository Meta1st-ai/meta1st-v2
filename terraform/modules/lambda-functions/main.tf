resource "aws_lambda_function" "pre_auth" {
  filename      = "${path.module}/lambda/zipped/pre_auth.zip"
  function_name = "metafirst-pre-authentication"
  role          = aws_iam_role.lambda_role.arn
  handler       = "pre_auth.handler"
  runtime       = var.lambda_runtime
  architectures = [var.lambda_architecture]
}

resource "aws_lambda_function" "post_auth" {
  filename      = "${path.module}/lambda/zipped/post_auth.zip"
  function_name = "metafirst-post-authentication"
  role          = aws_iam_role.lambda_role.arn
  handler       = "post_auth.handler"
  runtime       = var.lambda_runtime
  architectures = [var.lambda_architecture]
}

resource "aws_lambda_function" "user_migration" {
  filename      = "${path.module}/lambda/zipped/user_migration.zip"
  function_name = "metafirst-user-migration"
  role          = aws_iam_role.lambda_role.arn
  handler       = "user_migration.handler"
  runtime       = var.lambda_runtime
  architectures = [var.lambda_architecture]
}

# Lambda permissions for Cognito to invoke functions
resource "aws_lambda_permission" "cognito_pre_auth" {
  statement_id  = "AllowCognitoInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pre_auth.function_name
  principal     = "cognito-idp.amazonaws.com"
}

resource "aws_lambda_permission" "cognito_post_auth" {
  statement_id  = "AllowCognitoInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_auth.function_name
  principal     = "cognito-idp.amazonaws.com"
}

resource "aws_lambda_permission" "cognito_user_migration" {
  statement_id  = "AllowCognitoInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_migration.function_name
  principal     = "cognito-idp.amazonaws.com"
}

resource "aws_iam_role" "lambda_role" {
  name = "metafirst-lambda-role"

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

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}
