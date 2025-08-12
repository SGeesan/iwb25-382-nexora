import ballerina/http;
import ballerina/io;
import ballerina/jwt;
import BalService.util;

// JWT configuration constants
configurable string ISSUER = "nexora";
configurable string AUDIENCE = "client";
configurable string CERT_FILE = "./resource/alice.crt";
configurable string PRIVATE_KEY_FILE = "./resource/alice.key";

// Microservice configuration
configurable string USER_HANDLER_SERVICE_URL = "http://localhost:5000/api";

public isolated function login(string email, string password) returns http:NotFound|json|error {
    io:println("Attempting to login with email: " + email);

    http:Client mongoClient = check new (USER_HANDLER_SERVICE_URL);
    http:Response response = check mongoClient->get("/user/getByEmail?email=" + email);

    io:println("Received response from Node.js backend. Status code: " + response.statusCode.toString());

    json userDetails = check response.getJsonPayload();
    io:println("Received user details: " + userDetails.toJsonString());

    if userDetails is map<json> && userDetails.email is string && userDetails.password is string {
        // Hash the password provided by user in login request
        string hashedInputPassword = check util:md5Hash(password);

        // Compare hashed input password with stored hashed password
        if userDetails.email == email && userDetails.password == hashedInputPassword {
            io:println("User signed in successfully!");

            json Role = check userDetails.role;
            string userRole = Role.toString();
            json user_name = check userDetails.user_name;
            string userName = user_name.toString();

            jwt:IssuerConfig issuerConfig = {
                    username: userName,
                    issuer: ISSUER,
                    audience: AUDIENCE,
                    expTime: 3600,
                    customClaims: {
                            "email": email,
                            "role": userRole
                        },
                    signatureConfig: {config: {keyFile: PRIVATE_KEY_FILE}}
                };
            string jwt = check jwt:issue(issuerConfig);
            return {"token": jwt};
        }
        else {
            io:println("Invalid email or password");
            http:NotFound notFoundResponse = {body: "Invalid email or password"};
            return notFoundResponse;
        }
    } else {
        string res_message = "Unknown error";
        if userDetails is map<json> && userDetails.message is string {
            json Message = check userDetails.message;
            res_message = Message.toString();
        }
        return error(res_message);
    }
}

public isolated function register(string username, string email, string role, string password) returns http:Response|error{
    string hashedPassword = check util:md5Hash(password);
    http:Client mongoClient = check new (USER_HANDLER_SERVICE_URL);
    json data = {"user_name":username,
    "password":hashedPassword,
    "role":role,
    "email":email};
    http:Response response = check mongoClient->post("/user/registerUser",data);
    return response;
}