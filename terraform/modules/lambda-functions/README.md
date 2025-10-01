# lambda-functions module

This module is used to create AWS Lambda functions for MetaFirst authentication triggers in AWS.

**Important note!**

Lambda function ZIP files (pre_auth.zip, post_auth.zip, user_migration.zip) must be present in the module directory before deployment. The functions contain placeholder code that needs customer-specific implementation.

The module is intended to use as module dependency.


## Version

1.0.0


## Table of Contents

- [lambda-functions module](#lambda-functions-module)
  - [Version](#version)
  - [Table of Contents](#table-of-contents)
  - [Created Resources](#created-resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Terraform Lifecycle Rules](#terraform-lifecycle-rules)


## Created Resources

| Name | Type |
|------|------|
| pre_auth | aws_lambda_function |
| post_auth | aws_lambda_function |
| user_migration | aws_lambda_function |
| lambda_role | aws_iam_role |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| lambda_runtime | Lambda runtime | string | - | Y |
| lambda_architecture | Lambda architecture | string | - | Y |


## Outputs

| Name | Description |
|------|-------------|
| lambda_functions | Lambda function ARNs (pre_auth, post_auth, user_migration) |


## Terraform Lifecycle Rules

There is not applied any.
