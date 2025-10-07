# Amazon Cognito with Azure AD Integration Guide

## Overview
This guide covers implementing authentication for applications using Amazon Cognito User Pools with Azure AD integration, including user migration strategies and synchronization patterns.

## Architecture Setup
- **User Pools**: Admin and Employee user pools
- **Triggers**: Pre/Post/Migration Lambda functions
- **Sync**: Scheduled Lambda for Azure AD synchronization
- **Application**: EC2-hosted application

## Authentication Implementation

### SSO Flow (Recommended)
- Configure Cognito User Pool with Azure AD as SAML/OIDC identity provider
- Users authenticate directly with Azure AD
- Azure AD returns tokens to Cognito
- Application receives Cognito tokens for AWS resource access

### Non-SSO Flow
- Users authenticate directly with Cognito User Pool
- Requires user migration from Azure AD to Cognito
- Users maintain separate credentials in Cognito

## User Migration Lambda Triggers

### When Migration Lambda Triggers
- **Event**: User attempts to sign in to Cognito but doesn't exist in the User Pool
- **Timing**: Real-time during authentication attempt
- **Trigger**: `UserMigration_Authentication` event
- **Process**: Lambda queries Azure AD, validates credentials, creates user in Cognito

### Key Implementation
```python
def lambda_handler(event, context):
    trigger_source = event['triggerSource']
    
    if trigger_source == 'UserMigration_Authentication':
        # User trying to sign in but doesn't exist
        username = event['userName']
        password = event['request']['password']
        
        # Validate against Azure AD
        if validate_azure_ad_user(username, password):
            return {
                'response': {
                    'userAttributes': {
                        'email': get_user_email_from_azure(username),
                        'email_verified': 'true'
                    },
                    'finalUserStatus': 'CONFIRMED',
                    'messageAction': 'SUPPRESS'
                }
            }
```

## Sync Lambda and User Deletion

### User Deletion Behavior
- If Azure AD user is deleted, your sync lambda should detect this
- Recommended approach: Disable/archive user in Cognito rather than delete
- Cognito user deletion removes all associated data permanently

### Sync Lambda Implementation
```python
def sync_users():
    # Get all users from Azure AD
    azure_users = get_azure_ad_users()
    cognito_users = get_cognito_users()
    
    # Handle deleted users
    for cognito_user in cognito_users:
        if cognito_user not in azure_users:
            # Option 1: Disable user
            disable_cognito_user(cognito_user['Username'])
            # Option 2: Delete user (not recommended)
            # delete_cognito_user(cognito_user['Username'])
```

## Important Development Considerations

### SSO vs Non-SSO Decision Factors

**Choose SSO when:**
- Users already authenticate with Azure AD daily
- Centralized user management is priority
- Compliance requires single identity source
- Minimal user friction needed

**Choose Non-SSO when:**
- Application needs offline capability
- Custom authentication flows required
- Azure AD integration complexity is concern

### Critical Implementation Details

1. **Token Management:**
   - SSO: Handle SAML/OIDC token exchange
   - Non-SSO: Manage Cognito JWT tokens directly

2. **User Attributes Mapping:**
   - Map Azure AD attributes to Cognito user attributes
   - Handle attribute updates during sync

3. **Error Handling:**
   - Migration lambda failures should not block authentication
   - Implement retry logic for Azure AD connectivity issues

4. **Security Considerations:**
   - Store Azure AD credentials securely (AWS Secrets Manager)
   - Implement proper CORS for web applications
   - Use least privilege IAM roles for lambdas

5. **Monitoring:**
   - CloudWatch logs for migration attempts
   - Metrics for sync lambda success/failure rates
   - Alerts for authentication failures

## Recommended Architecture
For your use case with existing Azure AD users, implement SSO with Cognito as the identity broker. This eliminates the need for user migration lambdas and provides seamless user experience while maintaining centralized identity management in Azure AD.
