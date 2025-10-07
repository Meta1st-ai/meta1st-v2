import json

def handler(event, context):
    """
    User Migration Lambda Trigger
    Handle user migration from external systems
    The user_migration Lambda in Cognito is only 
    triggered when a user attempts to sign in and 
    does not exist in the user pool. 
    It is used for just-in-time migration from legacy systems 
    (e.g., an old database or another IdP) during the authentication flow.
    """
    
    # Log the event for debugging
    print(f"User migration event: {json.dumps(event)}")
    
    # Add custom logic here
    # Example: Validate user credentials, migrate user data, etc.
    
    return event
