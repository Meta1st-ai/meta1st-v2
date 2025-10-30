const { MongoClient } = require("mongodb");

exports.handler = async (event, context) => {
  // Add your pre-auth logic here

  //Purpose: Runs before user authentication to validate or block login attempts
  //Common Use Cases:
  //• IP address validation
  //• Device fingerprinting
  //• Rate limiting
  //• Custom business logic validation
  console.log("Pre-auth event:", JSON.stringify(event));

  if (event.httpMethod !== "POST") {
    return {
      statusCode: 405,
      body: JSON.stringify({ success: false, message: "Method Not Allowed" }),
    };
  }

  try {
    let cachedClient = null;
    const body = JSON.parse(event.body || "{}");
    const email = body.email?.toLowerCase();

    if (!email) {
      return {
        statusCode: 400,
        body: JSON.stringify({
          success: false,
          message: "Email is required",
          data: {},
        }),
      };
    }

    const client = cachedClient || new MongoClient(MONGODB_URI);
    if (!client) {
      await client.connect();
      cachedClient = client;
    }

    const db = client.db();

    const userCollection = db.collection("users");

    const findUser = await userCollection.findOne({
      email: email.toLowerCase(),
    });

    if (!findUser) {
      return {
        statusCode: 404,
        body: JSON.stringify({
          success: false,
          message: "User not found!",
          data: {},
        }),
      };
    }

    if (findUser?.isSSOUser) {
      const redirectUrl = new URL(`https://${COGNITO_DOMAIN}/oauth2/authorize`);
      redirectUrl.search = new URLSearchParams({
        client_id: COGNITO_CLIENT_ID,
        response_type: "code",
        scope: "openid profile email",
        redirect_uri: COGNITO_REDIRECT_URI,
        identity_provider: "AzureAD",
      }).toString();

      return {
        statusCode: 200,
        body: JSON.stringify({
          success: true,
          isSSOUser: true,
          url: redirectUrl.toString(),
        }),
      };
    } else {
      return {
        statusCode: 200,
        body: JSON.stringify({
          success: true,
          isSSOUser: false,
          url: null,
        }),
      };
    }
    // return event;
  } catch (error) {
    console.error("Error occured while checking pre authentication: ", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        success: false,
        message: "Internal server error!",
        data: {},
      }),
    };
  }
};
