# employee-user-pool module

This module is used to create AWS Cognito User Pool for MetaFirst employees with hybrid authentication (manual + Azure AD SSO) in AWS.

**Important note!**

This module supports both manual user creation and Azure AD SAML 2.0 federation. The azure_metadata_url must be provided for SSO functionality. This module is designed to be reusable for onboarding new customers.

The module is intended to use as module dependency.


## Version

1.0.0


## Table of Contents

- [employee-user-pool module](#employee-user-pool-module)
  - [Version](#version)
  - [Table of Contents](#table-of-contents)
  - [Created Resources](#created-resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Terraform Lifecycle Rules](#terraform-lifecycle-rules)


## Created Resources

| Name | Type |
|------|------|
| employee_pool | aws_cognito_user_pool |
| azure_ad | aws_cognito_identity_provider |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pool_name | Name of the employee user pool | string | - | Y |
| aws_region | AWS region | string | - | Y |
| azure_metadata_url | Azure AD SAML metadata URL | string | "" | N |


## Outputs

| Name | Description |
|------|-------------|
| user_pool_id | Employee User Pool ID |
| user_pool_arn | Employee User Pool ARN |
| identity_provider_name | Azure AD Identity Provider name |


## Terraform Lifecycle Rules

There is not applied any.
