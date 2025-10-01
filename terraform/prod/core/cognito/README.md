# MetaFirst Terraform Project

This Terraform project implements the MetaFirst authentication system with AWS Cognito User Pools and Lambda functions.

## Architecture

- **S3 Backend**: Terraform state storage with DynamoDB locking
- **Admin User Pool**: For organization administrators
- **Employee User Pool**: Hybrid authentication (manual + Azure AD SSO)
- **Lambda Functions**: Authentication flow customization

## Prerequisites

1. AWS CLI configured
2. Terraform >= 1.0 installed
3. Azure AD metadata URL (for SSO setup)

## Deployment

### 1. Deploy Backend Infrastructure First

```bash
cd prod/backend
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

### 2. Deploy Core Application

```bash
cd ../core
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

## Configuration

### Variables
- `aws_region`: AWS region (default: eu-west-1)
- `lambda_runtime`: Lambda runtime (default: python3.11)
- `lambda_architecture`: Lambda architecture (default: x86_64)

### Azure AD Setup
Update the `azure_metadata_url` variable in prod.tfvars with your Azure AD SAML metadata URL.

## Lambda Functions

The project includes three Lambda functions for authentication flows:
- **pre_auth**: Pre-authentication trigger
- **post_auth**: Post-authentication trigger  
- **user_migration**: User migration trigger

Customize these functions in the `lambda/` directory according to your requirements.

## Module Structure

The employee user pool is implemented as a reusable module to support onboarding new customers.

## Project Structure

```
metafirst/
├── prod/
│   ├── backend/          # Backend infrastructure (S3, DynamoDB)
│   └── core/             # Core application (User Pools, Lambda)
├── modules/              # Reusable Terraform modules
├── lambda/               # Lambda function source code
└── README.md
```
