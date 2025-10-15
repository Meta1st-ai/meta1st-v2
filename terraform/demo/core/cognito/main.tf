####################################################################
# Admin User Pool Module
####################################################################
module "user_pool_1" {
  source = "../../../modules/user_pool_1"

  environment               = var.environment
  pool_name                 = var.user_pool_1_name
  pre_auth_lambda_arn       = module.lambda_functions.pre_auth_arn
  post_auth_lambda_arn      = module.lambda_functions.post_auth_arn
  user_migration_lambda_arn = module.lambda_functions.user_migration_arn
}

####################################################################
# Employee User Pool Module
####################################################################
module "user_pool_2" {
  source = "../../../modules/user_pool_2"

  environment               = var.environment
  pool_name                 = var.user_pool_2_name
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

  environment         = var.environment
  lambda_runtime      = var.lambda_runtime
  lambda_architecture = var.lambda_architecture
}

####################################################################
# Sync Cognito with Azure AD Module
####################################################################
module "sync_cognito_azuread" {
  source = "../../../modules/sync-cognito-azuread"

  environment              = var.environment
  azure_tenant_id          = var.azure_tenant_id
  azure_client_id          = var.azure_client_id
  azure_client_secret      = var.azure_client_secret
  sync_lambda_runtime      = var.sync_lambda_runtime
  sync_lambda_architecture = var.sync_lambda_architecture
  cognito_user_pool_id     = module.user_pool_2.user_pool_id
  aws_region               = var.aws_region
}