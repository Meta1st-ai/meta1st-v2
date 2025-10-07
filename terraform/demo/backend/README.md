# MetaFirst Backend Infrastructure

This directory contains the Terraform backend infrastructure (S3 bucket and DynamoDB table) that must be deployed before the main MetaFirst application.

## Resources Created

- **S3 Bucket**: `metafirst-terraform-state-{account_id}` - Stores Terraform state files
- **DynamoDB Table**: `metafirst-terraform-locks` - Provides state locking

## Deployment Order

1. **Deploy Backend First** (this directory):
   ```bash
   cd <..>/metafirst/demo/backend
   terraform init
   terraform plan
   terraform apply 
   ```

2. **Update Main Application Backend Configuration**:
   - Replace `account_id` in `/metafirst/terraform.tfvars` with your actual account ID

3. **Then Deploy Main Application**:
   ```bash
   cd <..>/metafirst/demo/core/cognito/
   terraform init
   terraform plan 
   terraform apply
   ```

## Important Notes

- The `account_id` variable is required to make the S3 bucket name globally unique
- This backend infrastructure must exist before deploying the main application
- Do not delete these resources while the main application is deployed
