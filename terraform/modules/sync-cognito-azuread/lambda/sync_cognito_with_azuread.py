import json

def handler(event, context):
    """
    Sync Cognito users with Azure AD    
    """
    
    # Log the event for debugging
    print(f"User migration event: {json.dumps(event)}")
    
    # Add custom logic here
    # Example: AdminUpdateUserAttributes, AdminDeleteUser, etc.
    
    return event
