output "user_pool_id" {
  description = "user_pool_2 User Pool ID"
  value       = aws_cognito_user_pool.user_pool_2_pool.id
}

output "user_pool_arn" {
  description = "user_pool_2 User Pool ARN"
  value       = aws_cognito_user_pool.user_pool_2_pool.arn
}

output "app_client_id" {
  description = "user_pool_2 App Client ID"
  value       = aws_cognito_user_pool_client.user_pool_2_app_client.id
}

output "hosted_ui_domain" {
  description = "Hosted UI Domain for SAML"
  value       = "https://${aws_cognito_user_pool_domain.user_pool_2_domain.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}
