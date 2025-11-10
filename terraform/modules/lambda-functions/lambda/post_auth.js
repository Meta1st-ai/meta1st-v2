// const { MongoClient } = require("mongodb");
// const axios = require("axios");
// const jwt = require("jsonwebtoken");
// const dotenv = require("dotenv");
// dotenv.config();

exports.handler = async (event, context) => {
  // Add your post-auth logic here

  //Purpose: Runs after successful authentication to perform additional actions
  //Common Use Cases:
  //• Logging successful logins
  //• Updating user attributes
  //• Triggering notifications
  //• Analytics and audit trails
  console.log("Post-auth event:", JSON.stringify(event));
  console.log("Post-auth context:", JSON.stringify(context));
  
  return event;

  // try {
  //   if (event.httpMethod !== "POST") {
  //     return {
  //       statusCode: 405,
  //       body: JSON.stringify({ success: false, message: "Method Not Allowed" }),
  //     };
  //   }

  //   const body = JSON.parse(event.body || "{}");
  //   const code = body.code;

  //   if (!code) {
  //     return {
  //       statusCode: 400,
  //       body: JSON.stringify({
  //         success: false,
  //         message: "Missing authorization code",
  //       }),
  //     };
  //   }

  //   let cachedClient = null;

  //   const client = cachedClient || new MongoClient(process.env.MONGODB_URI);
  //   if (!client) {
  //     await client.connect();
  //     cachedClient = client;
  //   }

  //   const db = client.db();

  //   const userCollection = db.collection("users");

  //   const tokenRes = await axios.post(
  //     `https://${process.env.COGNITO_DOMAIN}/oauth2/token`,
  //     new URLSearchParams({
  //       grant_type: "authorization_code",
  //       code,
  //       redirect_uri: process.env.COGNITO_REDIRECT_URI,
  //       client_id: process.env.COGNITO_CLIENT_ID,
  //     }),
  //     {
  //       headers: {
  //         "Content-Type": "application/x-www-form-urlencoded",
  //         Authorization:
  //           "Basic " +
  //           Buffer.from(
  //             `${process.env.COGNITO_CLIENT_ID}:${process.env.COGNITO_CLIENT_SECRET}`
  //           ).toString("base64"),
  //       },
  //     }
  //   );

  //   const { id_token } = tokenRes.data;

  //   // 2️⃣ Verify ID token
  //   const decoded = jwt.decode(id_token, { complete: true });

  //   const allowedGroups = {
  //     "620782cc-ee1f-419d-953d-5029e3c8a935": "admin", // Cognito Admin
  //     "338cfd46-de0f-4bcf-9b12-8c758d210784": "user", // Cognito standard user
  //   };

  //   if (
  //     !Object.keys(allowedGroups).includes(decoded?.payload?.["custom:groups"])
  //   ) {
  //     return {
  //       ststusCode: 401,
  //       body: JSON.stringify({
  //         success: false,
  //         message: "User not authorized (invalid Azure AD group)",
  //       }),
  //     };
  //   }

  //   if (decoded?.payload) {
  //     await userCollection.findOneAndUpdate(
  //       { email: decoded?.payload?.email.toLowerCase() },
  //       {
  //         $set: {
  //           firstName: decoded?.payload?.given_name,
  //           lastName: decoded?.payload?.family_name,
  //           email: decoded?.payload?.email.toLowerCase(),
  //           lastLoggedIn: new Date(),
  //           ssoProvider: "AzureAD",
  //           emailVerified: true,
  //           isActive: true,
  //           isSSOUser: true,
  //           roles: [allowedGroups[decoded?.payload?.["custom:groups"]]],
  //           azureObjectId: decoded.payload?.["custom:object_id"],
  //           azureGroupId: decoded.payload?.["custom:groups"],
  //           theme: "#5932EA",
  //           primaryColor: "#5422be",
  //           secondaryColor: "#e087fd",
  //           degrees: 45,
  //           language: "en",
  //           timeZone: "+0:00",
  //           cognitoSub: decoded.payload.sub,
  //         },
  //       },
  //       { upsert: true, returnDocument: "after" }
  //     );
  //   }

  //   const user = await userCollection.findOne({
  //     email: decoded.payload.email.toLowerCase(),
  //   });

  //   const payload = {
  //     email: user.email,
  //     id: user._id,
  //     roles: user.roles,
  //     twoFactorSecret: user.twoFactorSecret,
  //   };

  //   const payloadToReturn = {
  //     twoFactorEnabled: user.twoFactorEnabled,
  //     access_token: jwt.sign(payload),
  //     user,
  //   };

  //   return {
  //     statusCode: 200,
  //     body: JSON.stringify({
  //       success: true,
  //       message: "User logged in successfully",
  //       data: payloadToReturn,
  //     }),
  //   };
  // } catch (error) {
  //   console.error(
  //     "Error occured while checking post authentication: ",
  //     error
  //   );
  //   return {
  //     statusCode: 500,
  //     body: JSON.stringify({
  //       success: false,
  //       message: "Internal server error!",
  //       data: {},
  //     }),
  //   };
  // }
};
