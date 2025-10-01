output "admin_user_pool_id" {
  description = "Admin User Pool ID"
  value       = module.admin_user_pool.user_pool_id
}

output "admin_user_pool_arn" {
  description = "Admin User Pool ARN"
  value       = module.admin_user_pool.user_pool_arn
}

output "admin_app_client_id" {
  description = "Admin App Client ID"
  value       = module.admin_user_pool.app_client_id
}

output "admin_hosted_ui_domain" {
  description = "Admin Hosted UI Domain"
  value       = module.admin_user_pool.hosted_ui_domain
}

output "employee_user_pool_id" {
  description = "Employee User Pool ID"
  value       = module.employee_user_pool.user_pool_id
}

output "employee_user_pool_arn" {
  description = "Employee User Pool ARN"
  value       = module.employee_user_pool.user_pool_arn
}

output "employee_app_client_id" {
  description = "Employee App Client ID"
  value       = module.employee_user_pool.app_client_id
}

output "employee_hosted_ui_domain" {
  description = "Employee Hosted UI Domain for SAML"
  value       = module.employee_user_pool.hosted_ui_domain
}

output "lambda_functions" {
  description = "Lambda function ARNs"
  value       = module.lambda_functions.lambda_functions
}
