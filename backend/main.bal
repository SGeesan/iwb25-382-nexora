import ballerina/http;
import ballerina/io;
import ballerina/jwt;

listener http:Listener mainListner = new (9090);

// JWT configuration constants
const string ISSUER = "nexora";
const string AUDIENCE = "client";
const string CERT_FILE = "./resource/public/public.crt";
const string PRIVATE_KEY_FILE = "./resource/private/private.key";
const string SCOPE_KEY = "scp";

// Microservice configuration
const string USER_HANDLER_SERVICE_URL = "localhost:9091";

http:JwtValidatorConfig validatorConfig = {
                    issuer: ISSUER,
                    audience: AUDIENCE,
                    signatureConfig: {
                        certFile: CERT_FILE},
                    scopeKey: SCOPE_KEY};

isolated function get_username_from_BearerToken(string token, jwt:ValidatorConfig validatorConfig) returns string|error {
    if token.substring(0, 7) != "Bearer " {
        return error("Unauthorized: Invalid Authorization header format");
    }
    string jwtToken = token.substring(7); // Remove "Bearer " prefix
    jwt:ListenerJwtAuthProvider provider = new (validatorConfig);
    jwt:Payload payload = check provider.authenticate(jwtToken);
    string? username = payload.sub;
    if username is null {
        return error("Unauthorized: No username found in JWT");
    }
    return username;
}

service / on mainListner {
    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig,
                scopes: ["user"]}]}
    isolated resource function get hello(@http:Header string Authorization) returns string|error {
        // Validate the JWT token and extract the username
        http:JwtValidatorConfig validatorConfig = {
                    issuer: ISSUER, audience: AUDIENCE,
                    signatureConfig: {certFile: CERT_FILE},
                    scopeKey: SCOPE_KEY};
        string username = check get_username_from_BearerToken(Authorization, validatorConfig);

        return "Hi " + username + ", this is a secured endpoint!";
    }

    isolated resource function post login(map<json> details) returns json|error {
        // Retrieve the username and password.
        json name = check details.name;
        json password = check details.password;
        io:println("Checking if user exists with name: " + name.toString() + " and password: " + password.toString());
        // http:Client userClient = check new (USER_HANDLER_SERVICE_URL);
        // json userDetails = {name: name.toString(), password: password.toString()};
        // http:Response response = check userClient->post("/verifyUser", userDetails);
        io:println("User signed in successfully!");

        // Return a jwt token
        jwt:IssuerConfig issuerConfig = {
            username: name.toString(),
            issuer: ISSUER,audience: AUDIENCE,
            expTime: 3600,
            customClaims: {[SCOPE_KEY]: "user"},
            signatureConfig: {config: {keyFile: PRIVATE_KEY_FILE}}};
        string jwt = check jwt:issue(issuerConfig);
        return {"token": jwt};
    }

    isolated resource function post signup(map<json> details) returns http:Created|error {
        // Retrieve the username and password.
        json name = check details.name;
        json password = check details.password;

        // Save in the database
        io:println("Saving new user with name: " + name.toString() + " and password: " + password.toString());
        // http:Client userClient = check new (USER_HANDLER_SERVICE_URL);
        // json userDetails = {name: name.toString(), password: password.toString()};
        // http:Response response = check userClient->post("/saveUser", userDetails);
        io:println("User signed up successfully!");
        return http:CREATED;
    }
}
