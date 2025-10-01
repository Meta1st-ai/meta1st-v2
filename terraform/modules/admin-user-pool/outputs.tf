output "user_pool_id" {
  description = "Admin User Pool ID"
  value       = aws_cognito_user_pool.admin_pool.id
}

output "user_pool_arn" {
  description = "Admin User Pool ARN"
  value       = aws_cognito_user_pool.admin_pool.arn
}

output "app_client_id" {
  description = "Admin App Client ID"
  value       = aws_cognito_user_pool_client.admin_app_client.id
}

output "hosted_ui_domain" {
  description = "Admin Hosted UI Domain"
  value       = "https://${aws_cognito_user_pool_domain.admin_domain.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}
