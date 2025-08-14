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
    User user = check mongoClient->/user/getByEmail(email = email);

    io:println("Received user details: " + user.toJsonString());
    // Hash the password provided by user in login request
    string hashedInputPassword = check util:md5Hash(password);

    // Compare hashed input password with stored hashed password
    if user.email == email && user.password == hashedInputPassword {
        io:println("User signed in successfully!");
        string Role = user.role;
        string userName = user.user_name;

        jwt:IssuerConfig issuerConfig = {
                    username: userName,
                    issuer: ISSUER,
                    audience: AUDIENCE,
                    expTime: 3600,
                    customClaims: {
                            "email": email,
                            "role": Role
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
}

public isolated function register(User newUser) returns http:Response|error {
    string hashedPassword = check util:md5Hash(newUser.password);
    http:Client mongoClient = check new (USER_HANDLER_SERVICE_URL);
    json data = {"user_name": newUser.user_name,
        "password": hashedPassword,
        "role": newUser.role,
        "email": newUser.email};
    http:Response response = check mongoClient->/user/registerUser.post(data);
    return response;
}
