 #output "user_pool_1_id" {
  # description = "Admin User Pool ID"
  # value       = module.user_pool_1.user_pool_id
 #}

 #output "user_pool_1_arn" {
  # description = "Admin User Pool ARN"
  # value       = module.user_pool_1.user_pool_arn
 #}

 #output "admin_app_client_id" {
  # description = "Admin App Client ID"
  # value       = module.user_pool_1.app_client_id
 #}

 #output "admin_hosted_ui_domain" {
 # description = "Admin Hosted UI Domain"
 #  value       = module.user_pool_1.hosted_ui_domain
 #}

output "user_pool_2_id" {
  description = "Employee User Pool ID"
  value       = module.user_pool_2.user_pool_id
} 

output "user_pool_2_arn" {
  description = "Employee User Pool ARN"
  value       = module.user_pool_2.user_pool_arn
}

output "employee_app_client_id" {
  description = "Employee App Client ID"
  value       = module.user_pool_2.app_client_id
}

output "employee_hosted_ui_domain" {
  description = "Employee Hosted UI Domain for SAML"
  value       = module.user_pool_2.hosted_ui_domain
}

output "lambda_functions" {
  description = "Lambda function ARNs"
  value       = module.lambda_functions.lambda_functions
}
