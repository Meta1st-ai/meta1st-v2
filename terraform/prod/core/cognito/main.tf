####################################################################
# Admin User Pool Module
####################################################################
module "admin_user_pool" {
  source = "../../../modules/admin-user-pool"

  pool_name                 = "Demo-MetaFirst-Admin-UserPool"
  pre_auth_lambda_arn       = module.lambda_functions.pre_auth_arn
  post_auth_lambda_arn      = module.lambda_functions.post_auth_arn
  user_migration_lambda_arn = module.lambda_functions.user_migration_arn
}

####################################################################
# Employee User Pool Module
####################################################################
module "employee_user_pool" {
  source = "../../../modules/employee-user-pool"

  pool_name                 = "Demo-MetaFirst-Employee-UserPool"
  aws_region                = var.aws_region
  azure_metadata_url        = var.azure_metadata_url
  pre_auth_lambda_arn       = module.lambda_functions.pre_auth_arn
  post_auth_lambda_arn      = module.lambda_functions.post_auth_arn
  user_migration_lambda_arn = module.lambda_functions.user_migration_arn
}

####################################################################
# Trigger Lambda Functions Module
####################################################################
module "lambda_functions" {
  source = "../../../modules/lambda-functions"

  lambda_runtime      = var.lambda_runtime
  lambda_architecture = var.lambda_architecture
}

####################################################################
# Sync Cognito with Azure AD Module
####################################################################
module "sync_cognito_azuread" {
  source                   = "../../../modules/sync-cognito-azuread"
  azure_tenant_id          = var.azure_tenant_id
  azure_client_id          = var.azure_client_id
  azure_client_secret      = var.azure_client_secret
  sync_lambda_runtime      = var.sync_lambda_runtime
  sync_lambda_architecture = var.sync_lambda_architecture
  cognito_user_pool_id     = module.employee_user_pool.user_pool_id
  aws_region               = var.aws_region
}