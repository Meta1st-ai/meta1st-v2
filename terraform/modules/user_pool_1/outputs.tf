output "user_pool_id" {
  description = "Admin User Pool ID"
  value       = aws_cognito_user_pool.user_pool_1.id
}

output "user_pool_arn" {
  description = "Admin User Pool ARN"
  value       = aws_cognito_user_pool.user_pool_1.arn
}

output "app_client_id" {
  description = "Admin App Client ID"
  value       = aws_cognito_user_pool_client.user_pool_1_app_client.id
}

output "hosted_ui_domain" {
  description = "Admin Hosted UI Domain"
  value       = "https://${aws_cognito_user_pool_domain.user_pool_1_domain.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}
