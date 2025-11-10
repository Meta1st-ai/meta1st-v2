// const { MongoClient } = require("mongodb");
// const axios = require("axios");
// const dotenv = require("dotenv");
// dotenv.config();


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
  console.log("User migration context:", JSON.stringify(context));
  
  return event;
  
  // try {
  //   if (event.httpMethod !== "POST") {
  //     return {
  //       statusCode: 405,
  //       body: JSON.stringify({ success: false, message: "Method Not Allowed" }),
  //     };
  //   }
  //   let accessToken;
  //   let cachedClient = null;

  //   const client = cachedClient || new MongoClient(process.env.MONGODB_URI);
  //   if (!client) {
  //     await client.connect();
  //     cachedClient = client;
  //   }

  //   const db = client.db();

  //   const userCollection = db.collection("users");

  //   async function getAzureGroups() {
  //     const tokenResponse = await axios.post(
  //       `https://login.microsoftonline.com/${process.env.AZURE_TENANT_ID}/oauth2/v2.0/token`,
  //       new URLSearchParams({
  //         client_id: process.env.AZURE_CLIENT_ID,
  //         client_secret: process.env.AZURE_CLIENT_SECRET,
  //         scope: "https://graph.microsoft.com/.default",
  //         grant_type: "client_credentials",
  //       }),
  //       { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
  //     );

  //     accessToken = tokenResponse?.data?.access_token;

  //     // For users
  //     // const usersRes = await axios.get("https://graph.microsoft.com/v1.0/users", {
  //     //   headers: { Authorization: `Bearer ${accessToken}` },
  //     // });

  //     // return usersRes.data.value; // array of Azure AD users

  //     // For groups
  //     const groupRes = await axios.get(
  //       "https://graph.microsoft.com/v1.0/groups",
  //       {
  //         headers: { Authorization: `Bearer ${accessToken}` },
  //       }
  //     );

  //     return groupRes?.data?.value; // array of Azure AD users
  //   }

  //   // const cognito = new CognitoIdentityProviderClient({
  //   //   region: AWS_REGION,
  //   // });

  //   // async function syncToCognito(azureUser: any, groupId: string) {
  //   //   // Check if user already exists
  //   //   const existing = await cognito.send(
  //   //     new ListUsersCommand({
  //   //       UserPoolId: COGNITO_USER_POOL_ID,
  //   //       Filter: `email = "${
  //   //         azureUser?.mail
  //   //       }"`,
  //   //     })
  //   //   );
  //   //   console.log(
  //   //     "🚀 ~ AuthController ~ syncToCognito ~ existing:",
  //   //     existing
  //   //   );

  //   //   if (existing?.Users && existing?.Users?.length) {
  //   //     console.log(`User already exists in Cognito: ${azureUser.mail}`);
  //   //     return;
  //   //   }

  //   //   // [
  //   //   //   {
  //   //   //     "dateCreated": "1761541382225",
  //   //   //     "userId": "samltestuser1@Meta1stHRMoutlook.onmicrosoft.com",
  //   //   //     "providerName": "AzureAD",
  //   //   //     "providerType": "SAML",
  //   //   //     "issuer": "https://sts.windows.net/d5a958b0-22e0-48ea-b9df-43956dd749a4/",
  //   //   //     "primary": "true"
  //   //   //   }
  //   //   // ]

  //   //   console.log("123123123: ", azureUser);
  //   //   console.log("123123123 mail: ", azureUser?.mail);

  //   //   // Create user
  //   //   await cognito.send(
  //   //     new AdminCreateUserCommand({
  //   //       UserPoolId: COGNITO_USER_POOL_ID,
  //   //       // Username: 'azuread_' + azureUser.mail,
  //   //       Username:
  //   //         azureUser?.mail,
  //   //       UserAttributes: [
  //   //         {
  //   //           Name: "email",
  //   //           Value:
  //   //             azureUser?.mail,
  //   //         },
  //   //         { Name: "email_verified", Value: "true" },
  //   //         { Name: "name", Value: azureUser.displayName },
  //   //         { Name: "given_name", Value: azureUser.givenName },
  //   //         { Name: "family_name", Value: azureUser.surname },
  //   //         { Name: "custom:groups", Value: groupId },
  //   //         { Name: "custom:object_id", Value: azureUser.id },
  //   //         // {
  //   //         //   Name: "identities",
  //   //         //   Value: JSON.stringify([
  //   //         //     {
  //   //         //       dateCreated: Date.now(),
  //   //         //       userId:
  //   //         //         azureUser?.mail,
  //   //         //       providerName: "AzureAD",
  //   //         //       providerType: "SAML",
  //   //         //       issuer:
  //   //         //         "https://sts.windows.net/d5a958b0-22e0-48ea-b9df-43956dd749a4/",
  //   //         //       primary: "true",
  //   //         //     },
  //   //         //   ]),
  //   //         // },
  //   //       ],
  //   //       MessageAction: "SUPPRESS", // don’t send invitation email
  //   //     })
  //   //   );

  //   //   console.log("873456745645 end");

  //   //   console.log(`User created in Cognito: ${azureUser.mail}`);
  //   // }

  //   async function syncToMongo(azureUser, groupId) {
  //     if (!azureUser?.mail) {
  //       return;
  //     }

  //     const allowedGroups = {
  //       "620782cc-ee1f-419d-953d-5029e3c8a935": "admin", // Cognito Admin
  //       "338cfd46-de0f-4bcf-9b12-8c758d210784": "user", // Cognito standard user
  //     };

  //     await userCollection.findOneAndUpdate(
  //       { email: azureUser?.mail?.toLowerCase() },
  //       {
  //         $set: {
  //           firstName: azureUser?.givenName,
  //           lastName: azureUser?.surname,
  //           password: "",
  //           email: azureUser?.mail?.toLowerCase(),
  //           lastLoggedIn: new Date(),
  //           ssoProvider: "AzureAD",
  //           emailVerified: true,
  //           isActive: true,
  //           isSSOUser: true,
  //           roles: [allowedGroups[groupId]],
  //           azureObjectId: azureUser?.id,
  //           azureGroupId: groupId,
  //           theme: "#5932EA",
  //           primaryColor: "#5422be",
  //           secondaryColor: "#e087fd",
  //           degrees: 45,
  //           language: "en",
  //           timeZone: "+0:00",
  //         },
  //       },
  //       { upsert: true, returnDocument: "after" }
  //     );
  //   }

  //   const azureGroups = await getAzureGroups();
  //   for (const group of azureGroups) {
  //     const groupMembersRes = await axios.get(
  //       `https://graph.microsoft.com/v1.0/groups/${group?.id}/members`,
  //       {
  //         headers: { Authorization: `Bearer ${accessToken}` },
  //       }
  //     );
  //     for (const member of groupMembersRes?.data?.value) {
  //       // await syncToCognito(member, group?.id);
  //       await syncToMongo(member, group?.id);
  //     }
  //   }

  //   return {
  //       statusCode: 200,
  //       body: JSON.stringify({
  //           success: true,
  //           message: "Users synced successfully",
  //           data: {},
  //       }),
  //   }
  // } catch (error) {
  //   console.error(
  //     "Error occured while syncing users: ",
  //     error?.response?.data?.error ?? error
  //   );
  //   return {
  //       statusCode: 500,
  //       body: JSON.stringify({
  //           success: false,
  //           message: "Internal server error!",
  //           data: {},
  //       }),
  //   }
  // }
};
