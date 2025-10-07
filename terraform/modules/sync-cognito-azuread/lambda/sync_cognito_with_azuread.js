exports.handler = async (event, context) => {
    /**
     * Sync Cognito users with Azure AD
     */

    // Log the event for debugging 
    console.log(`User migration event: ${JSON.stringify(event)}`);

    // Add custom logic here
    // Example: AdminUpdateUserAttributes, AdminDeleteUser, etc.

    return event;
};