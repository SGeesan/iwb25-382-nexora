import ballerina/http;
import ballerina/io;
import ballerina/jwt;
import ballerina/crypto;

listener http:Listener mainListner = new (9090);

// JWT configuration constants
const string ISSUER = "nexora";
const string AUDIENCE = "client";
const string CERT_FILE = "./resource/alice.crt";
const string PRIVATE_KEY_FILE = "./resource/alice.key";
const string SCOPE_KEY = "scp";

// Microservice configuration
const string USER_HANDLER_SERVICE_URL = "http://localhost:5000/api";

http:JwtValidatorConfig validatorConfig = {
    issuer: ISSUER,
    audience: AUDIENCE,
    signatureConfig: { certFile: CERT_FILE },
    scopeKey: SCOPE_KEY
};

function md5Hash(string input) returns string|error {
    byte[] inputBytes = input.toBytes();
    byte[] hashedBytes = crypto:hashMd5(inputBytes);
    return hashedBytes.toBase16();  // hex string
}

isolated function get_username_from_BearerToken(string token, jwt:ValidatorConfig validatorConfig) returns string|error {
    if token.substring(0, 7) != "Bearer " {
        return error("Unauthorized: Invalid Authorization header format");
    }
    string jwtToken = token.substring(7);
    jwt:ListenerJwtAuthProvider provider = new (validatorConfig);
    jwt:Payload payload = check provider.authenticate(jwtToken);
    string? username = payload.sub;
    if username is null {
        return error("Unauthorized: No username found in JWT");
    }
    return username;
}

// ===== Global CORS applied to the whole service =====
@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173"], // your Vue app URL
        allowCredentials: true,
        allowHeaders: ["Content-Type", "Authorization"],
        exposeHeaders: ["Content-Type", "Authorization"],
        allowMethods: ["GET", "POST", "OPTIONS"]
    }
}
service / on mainListner {

    @http:ResourceConfig {
        auth: [{ jwtValidatorConfig: validatorConfig, scopes: ["user"] }]
    }
    resource function get hello(@http:Header string Authorization) returns string|error {
        string username = check get_username_from_BearerToken(Authorization, validatorConfig);
        return "Hi " + username + ", this is a secured endpoint!";
    }

    resource function post login(map<json> details) returns json|error {
        json email = check details.email;
        string userEmail = email.toString();
        json password = check details.password;
        string userPassword = password.toString();

        io:println("Attempting to login with email: " + userEmail);

        http:Client mongoClient = check new (USER_HANDLER_SERVICE_URL);
        http:Response response = check mongoClient->get("/user/getByEmail?email=" + userEmail);

        io:println("Received response from Node.js backend. Status code: " + response.statusCode.toString());

        json userDetails = check response.getJsonPayload();
        io:println("Received user details: " + userDetails.toJsonString());

        if userDetails is map<json> && userDetails.email is string && userDetails.password is string {
            // Hash the password provided by user in login request
            string hashedInputPassword = check md5Hash(userPassword);
            
            // Compare hashed input password with stored hashed password
            if userDetails.email == userEmail && userDetails.password == hashedInputPassword {
                io:println("User signed in successfully!");

                json Role = check userDetails.role;
                string userRole = Role.toString();

                jwt:IssuerConfig issuerConfig = {
                    username: userEmail,
                    issuer: ISSUER,
                    audience: AUDIENCE,
                    expTime: 3600,
                    customClaims: {
                            [SCOPE_KEY]: "user",
                            "email": userEmail,
                            "role": userRole
                        },
                    signatureConfig: { config: { keyFile: PRIVATE_KEY_FILE } }
                };
                string jwt = check jwt:issue(issuerConfig);
                return { "token": jwt};
            }
        } else {
            string res_message = "Unknown error";
            if userDetails is map<json> && userDetails.message is string {
                json Message = check userDetails.message;
                res_message = Message.toString();
            }
            return error(res_message);
        }
    
    return error("Unauthorized: Invalid credentials");
    }
}
