output "user_pool_id" {
  description = "Employee User Pool ID"
  value       = aws_cognito_user_pool.employee_pool.id
}

output "user_pool_arn" {
  description = "Employee User Pool ARN"
  value       = aws_cognito_user_pool.employee_pool.arn
}

output "app_client_id" {
  description = "Employee App Client ID"
  value       = aws_cognito_user_pool_client.employee_app_client.id
}

output "hosted_ui_domain" {
  description = "Hosted UI Domain for SAML"
  value       = "https://${aws_cognito_user_pool_domain.employee_domain.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}
