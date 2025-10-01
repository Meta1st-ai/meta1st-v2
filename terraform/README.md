# MetaFirst Terraform Project

This Terraform project implements the MetaFirst cloud infrastructure.

## Project Structure

```
terraform/
├── prod/
│   ├── backend/            # Backend infrastructure (S3, DynamoDB)
│   └── core/               # Core application (User Pools, Lambda)
├── modules/                # Reusable Terraform modules
│   └── lambda-functions/   # Lambda function source code
└── README.md               # The current file
```

## Directory structure

- Modules
  This folder defines the modules used by the terraform environment. 
  Each of them describe individually what resources are being used.
- prod
  This folder defines the environment for the terraform infrastructure
  - backend
    This folder defines the backend infrastructure (S3, DynamoDB)
  - core
    This folder defines the core infrastructure
    This is the main folder for the project.
    Under this there are the projects which will define the infrastructure.
    It can be later extended with other project without modifying the other projects.
    - cognito
      This folder defines the cognito infrastructure (User Pools, Identity Pools, Lambda triggers)
    - <<'placeholder for new project folder'>>


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



