exports.handler = async (event, context) => {
    // User Migration Lambda Trigger
    // Handle user migration from external systems
    // The user_migration Lambda in Cognito is only 
    // triggered when a user attempts to sign in and 
    // does not exist in the user pool.
    // It is used for just-in-time migration from legacy systems 
    // (e.g., an old database or another IdP) during the authentication flow.

    //Purpose: Migrates users from Azure AD to Cognito during their first login attempt
    //Trigger Events:
    //• UserMigration_Authentication - User tries to sign in but doesn't exist in Cognito
    //• UserMigration_ForgotPassword - User requests password reset but doesn't exist in Cognito

    console.log("User migration event:", JSON.stringify(event));
    // Add custom logic here
    return event;
};