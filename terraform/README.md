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


## Creating and deploying a new environment

### 1. Creating a new environment.
If the same infrastructure needs to be deployed into a different environment, then just copy and paste the existing environment folder.

When the terraform backend needs to be copied and executed as well?
- If the new environment will go to a new account
- If the new environment will go to a new region AND you want a separate AWS S3 bucket for the statefiles and a separate AWS DynamoDB for the lock files.

In every other case the backend does not needs to be manipulated.

### 2. How to deploy a new env based on an existing env?
1. Make sure you copy paste the existing env to the newly named folder (for example dev or stage or prod etc..).
2. Make sure that you rename the environment variable value in the ```terraform.tfvars``` (```environment             = "Demo"```)
3. Make sure to rename the backed configuration as well in the provider.tf 
```
backend s3 {
  ...
  key    = "Demo/terraform.tfstate"
  ...
}
```
4. Run ```terraform init```, in the newly created folder
5. Apply any changes required
6. Run ```terraform plan``` and ```terraform apply``` according to your need.



#### Example with the current infra:
1. Copy paste the ```demo``` folder to ```dev```
2. Change the ```environment``` variable in the ```terraform.tfvars``` file to ```dev```
3. Change the ```key``` value in the ```provider.tf``` file to ```Dev/terraform.tfstate```
4. Run ```terraform init``` in the ```dev``` folder
5. Run ```terraform plan```
6. Run ```terraform apply```


## Notes
1. Make sure you don't change the terraform.tfvars file name to other name, else you will need to apppend ```--var-file=<filename>.tfvars``` each time you run terraform plan or apply
2. Make sure the environment variable name is lowercase letters!

