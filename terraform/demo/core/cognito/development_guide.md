# Amazon Cognito with Azure AD - Development Guide

## Detailed Technical Specifications

### 1. User Migration Lambda Trigger Details

**Trigger Conditions:**
- Only fires when user exists in Azure AD but NOT in Cognito User Pool
- Requires user to provide correct Azure AD credentials
- Lambda has 30-second timeout limit for Azure AD validation
- Failed validation returns authentication error to user

**Event Structure:**
```python
{
    "version": "1",
    "region": "us-east-1",
    "userPoolId": "us-east-1_XXXXXXXXX",
    "userName": "user@company.com",
    "triggerSource": "UserMigration_Authentication",
    "request": {
        "password": "user_provided_password",
        "validationData": {},
        "clientMetadata": {}
    },
    "response": {
        "userAttributes": {},
        "finalUserStatus": "CONFIRMED",
        "messageAction": "SUPPRESS"
    }
}
```

### 2. Azure AD Integration Specifics

**For SSO Implementation:**
- Configure Azure AD Enterprise Application
- Set up SAML 2.0 or OIDC connection
- Map Azure AD groups to Cognito User Pool groups
- Configure attribute mapping (email, name, department)

**Required Azure AD Permissions:**
- `User.Read.All` - Read user profiles
- `Group.Read.All` - Read group memberships
- `Directory.Read.All` - Read directory data

### 3. Sync Lambda Implementation Details

**Scheduling Options:**
- EventBridge (CloudWatch Events) - Recommended
- Lambda scheduled expressions: `rate(1 hour)` or `cron(0 */6 * * ? *)`

**Sync Strategy:**
```python
import boto3
from microsoft.graph import GraphServiceClient

def sync_cognito_with_azuread():
    # Initialize clients
    cognito = boto3.client('cognito-idp')
    graph_client = GraphServiceClient(credentials, scopes)
    
    # Get Azure AD users
    azure_users = graph_client.users.get()
    
    # Get Cognito users for both pools
    admin_users = get_cognito_users('admin-pool-id')
    employee_users = get_cognito_users('employee-pool-id')
    
    # Sync logic
    for azure_user in azure_users.value:
        user_pool_id = determine_user_pool(azure_user.job_title)
        sync_user_attributes(azure_user, user_pool_id)
```

### 4. User Deletion Handling

**Recommended Approach - User Disabling:**
```python
def disable_user(user_pool_id, username):
    cognito.admin_disable_user(
        UserPoolId=user_pool_id,
        Username=username
    )
    
    # Add custom attribute to track deletion
    cognito.admin_update_user_attributes(
        UserPoolId=user_pool_id,
        Username=username,
        UserAttributes=[
            {
                'Name': 'custom:azure_deleted',
                'Value': 'true'
            },
            {
                'Name': 'custom:deletion_date',
                'Value': datetime.now().isoformat()
            }
        ]
    )
```

### 5. Application Integration on EC2

**Authentication Flow for EC2 Application:**
```python
# Using AWS SDK for Python (Boto3)
import boto3
from warrant import Cognito

def authenticate_user(username, password, user_pool_type):
    user_pool_id = get_user_pool_id(user_pool_type)  # admin or employee
    client_id = get_client_id(user_pool_type)
    
    u = Cognito(user_pool_id, client_id, username=username)
    u.authenticate(password=password)
    
    return {
        'access_token': u.access_token,
        'id_token': u.id_token,
        'refresh_token': u.refresh_token
    }
```

### 6. Error Handling and Monitoring

**CloudWatch Metrics to Track:**
- Migration lambda invocations and errors
- Sync lambda success/failure rates
- Authentication attempts and failures
- User pool size changes

**Logging Strategy:**
```python
import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        logger.info(f"Migration attempt for user: {event['userName']}")
        # Migration logic
        logger.info("Migration successful")
    except Exception as e:
        logger.error(f"Migration failed: {str(e)}")
        logger.error(f"Event: {json.dumps(event)}")
        raise
```

### 7. Security Best Practices

**Secrets Management:**
```python
import boto3
import json

def get_azure_credentials():
    secrets_client = boto3.client('secretsmanager')
    secret = secrets_client.get_secret_value(SecretId='azure-ad-credentials')
    return json.loads(secret['SecretString'])
```

**IAM Role for Lambda:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:AdminCreateUser",
                "cognito-idp:AdminSetUserPassword",
                "cognito-idp:AdminUpdateUserAttributes",
                "cognito-idp:ListUsers"
            ],
            "Resource": "arn:aws:cognito-idp:*:*:userpool/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:*:*:secret:azure-ad-credentials*"
        }
    ]
}
```

## Implementation Checklist

### Pre-Development Setup
- [ ] Azure AD Enterprise Application configured
- [ ] Cognito User Pools created (Admin & Employee)
- [ ] Lambda execution roles with proper permissions
- [ ] Secrets Manager setup for Azure AD credentials
- [ ] CloudWatch logging configured

### Development Phase
- [ ] Migration Lambda functions implemented
- [ ] Sync Lambda function implemented
- [ ] Error handling and retry logic added
- [ ] Unit tests for Lambda functions
- [ ] Integration tests with Azure AD

### Deployment Phase
- [ ] Lambda functions deployed
- [ ] EventBridge rules configured for sync
- [ ] CloudWatch alarms set up
- [ ] Application authentication flow tested
- [ ] User migration flow tested

### Post-Deployment
- [ ] Monitor CloudWatch logs and metrics
- [ ] Test user deletion scenarios
- [ ] Validate sync frequency and performance
- [ ] Document troubleshooting procedures
