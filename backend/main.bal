import ballerina/http;
import BalService.util;
import BalService.authServices as auth;
listener http:Listener mainListner = new (9090);

// JWT configuration constants
configurable string ISSUER = "nexora";
configurable string AUDIENCE = "client";
configurable string CERT_FILE = "./resource/alice.crt";
configurable string PRIVATE_KEY_FILE = "./resource/alice.key";

// Microservice configuration
// configurable string USER_HANDLER_SERVICE_URL = "http://localhost:5000/api";

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

    isolated resource function post login(map<json> details) returns http:NotFound|json|error|error {
        json email = check details.email;
        string userEmail = email.toString();
        json password = check details.password;
        string userPassword = password.toString();

        return auth:login(userEmail, userPassword);
        }
    
    isolated resource function post register(map<json> details) returns http:Response|error|error|http:Forbidden {
        //user_name, email, role, password
        json user_name = check details.user_name;
        string username = user_name.toString();
        json email = check details.email;
        string userEmail = email.toString();
        json role = check details.role;
        string userRole = role.toString();
        json password = check details.password;
        string userPassword = password.toString();
        if userRole == "admin" {
            // Only allow admin role to be registered by the system
            http:Forbidden forbiddenResponse = {body: "Admin role cannot be registered by the system"};
            return forbiddenResponse;
        }
        return auth:register(username,userEmail,userRole,userPassword);
    }
}
