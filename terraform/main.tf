

  ####################################################################
  # Dynamic Cognito User Pool - Rejoice-Organisation
  ####################################################################
  module "user_pool_rejoice_organisation" {
    source = "./modules/user_pool_rejoice_organisation"
  
    environment               = var.environment
    pool_name                 = var.user_pool_rejoice_organisation_name
    aws_region                = var.aws_region
    azure_metadata_url        = var.user_pool_rejoice_organisation_azure_metadata_url
    azure_tenant_id           = var.user_pool_rejoice_organisation_azure_tenant_id
  
    # Using shared lambda module ARNs (unchanged)
    pre_auth_lambda_arn       = module.lambda_functions.pre_auth_arn
    post_auth_lambda_arn      = module.lambda_functions.post_auth_arn
    user_migration_lambda_arn = module.lambda_functions.user_migration_arn
  }
  
