# admin-user-pool module

This module is used to create AWS Cognito User Pool for MetaFirst administrators in AWS.

**Important note!**

This user pool is configured for admin-only user creation. Self-registration is disabled and only super admins can create admin accounts. Strong password policy is enforced with 12+ character minimum.

The module is intended to use as module dependency.


## Version

1.0.0


## Table of Contents

- [admin-user-pool module](#admin-user-pool-module)
  - [Version](#version)
  - [Table of Contents](#table-of-contents)
  - [Created Resources](#created-resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Terraform Lifecycle Rules](#terraform-lifecycle-rules)


## Created Resources

| Name | Type |
|------|------|
| admin_pool | aws_cognito_user_pool |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| pool_name | Name of the admin user pool | string | - | Y |


## Outputs

| Name | Description |
|------|-------------|
| user_pool_id | Admin User Pool ID |
| user_pool_arn | Admin User Pool ARN |


## Terraform Lifecycle Rules

There is not applied any.
