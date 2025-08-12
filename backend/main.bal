import ballerina/http;
import BalService.util;
import BalService.authServices;
listener http:Listener mainListner = new (9090);

// JWT configuration constants
const string ISSUER = "nexora";
const string AUDIENCE = "client";
const string CERT_FILE = "./resource/alice.crt";
const string PRIVATE_KEY_FILE = "./resource/alice.key";

// Microservice configuration
const string USER_HANDLER_SERVICE_URL = "http://localhost:5000/api";

http:JwtValidatorConfig validatorConfig = {
    issuer: ISSUER,
    audience: AUDIENCE,
    signatureConfig: { certFile: CERT_FILE },
    scopeKey: "role"
};

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
        auth: [{ jwtValidatorConfig: validatorConfig, scopes: ["admin"] }]
    }
    isolated resource function get hello(@http:Header string Authorization) returns string|error {
        string username = check util:get_username_from_BearerToken(Authorization);
        return "Hi " + username + ", this is a secured endpoint only for admins!";
    }

    isolated resource function post login(map<json> details) returns json|error {
        json email = check details.email;
        string userEmail = email.toString();
        json password = check details.password;
        string userPassword = password.toString();

        return authServices:login(userEmail, userPassword);
    
    //return error("Unauthorized: Invalid credentials");
    }
}
