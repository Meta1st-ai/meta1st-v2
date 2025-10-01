output "lambda_functions" {
  description = "Lambda function ARNs"
  value = {
    pre_auth       = aws_lambda_function.pre_auth.arn
    post_auth      = aws_lambda_function.post_auth.arn
    user_migration = aws_lambda_function.user_migration.arn
  }
}

output "pre_auth_arn" {
  description = "Pre-authentication Lambda function ARN"
  value       = aws_lambda_function.pre_auth.arn
}

output "post_auth_arn" {
  description = "Post-authentication Lambda function ARN"
  value       = aws_lambda_function.post_auth.arn
}

output "user_migration_arn" {
  description = "User migration Lambda function ARN"
  value       = aws_lambda_function.user_migration.arn
}
