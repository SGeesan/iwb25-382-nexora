import ballerina/http;
import ballerina/io;
import BalService.util;
import BalService.authServices as auth;
import BalService.fileServices as file;
import BalService.jobServices as jobs;
import BalService.llmServices as llm;

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

    // === Public endpoints ===
    isolated resource function post login(map<json> details) returns http:NotFound|json|error|error {
        json email = check details.email;
        string userEmail = email.toString();
        json password = check details.password;
        string userPassword = password.toString();

        return auth:login(userEmail, userPassword);
        }
    
    isolated resource function post register(auth:User newUser) returns http:Response|error|error|http:Forbidden {
        //user_name, email, role, password
        if newUser.role == "admin" {
            // Only allow admin role to be registered by the system
            http:Forbidden forbiddenResponse = {body: "Admin role cannot be registered by the system"};
            return forbiddenResponse;
        }
        return auth:register(newUser);
    }

    // === User endpoints ===
    isolated resource function post user/upload_cv(http:Request request) returns http:Response|error{
        // This endpoint allows users to upload their CVs
        // Please add @http:Header string Authorization to the function parameters to get the JWT token
        // string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        string username = "dummyUser"; // For testing purposes, replace with actual JWT validation
        stream<byte[], io:Error?> bytes = check request.getByteStream();
        return file:uploadFile(bytes, username);
    }

    isolated resource function get user/search_jobs()returns jobs:Job[]|http:NotFound|error {
        // This endpoint allows users to search for jobs
        // Please add @http:Header string Authorization to the function parameters to get the JWT token
        // string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        string username = "dummyUser"; // For testing purposes, replace with actual JWT validation
        
        // PDF -> images
        stream<byte[], io:Error?>[] images = file:getCVasImages(username);
        // if images.length() == 0 {
        //     http:NotFound notFoundResponse = {body: "No CVs found for the user"};
        //     return notFoundResponse;
        // }

        // Process images to extract json data
        json cv = llm:imagesToJsonCV(images);

        // Get all job tags in the system
        string[] allJobTags = check jobs:getAllJobTags();

        // Get all job tags that match the CV data
        string[] matchingTags = llm:getMatchingTags(allJobTags, cv);

        // Get the jobs from matched tags
        jobs:Job[] matchedJobs = check jobs:getJobsByTags(matchingTags);

        // Rank the jobs based on the CV data
        return llm:rankJobs(matchedJobs, cv);
    }

    // ==== Company endpoints ====
    isolated resource function post company/create_job(jobs:JobPost newJob) returns http:Response|error {
        // This endpoint allows companies to create jobs
        // Please add @http:Header string Authorization to the function parameters to get the JWT token
        // string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        string username = "dummyUser"; // For testing purposes, replace with actual JWT validation
        return jobs:createJob(newJob, username);
    }
    isolated resource function get company/get_all_jobs() returns jobs:Job[]|error {
        // This endpoint allows users to get all job tags
        // Please add @http:Header string Authorization to the function parameters to get the JWT token
        // string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        string username = "dummyUser"; // For testing purposes, replace with actual JWT validation
        return jobs:getAllJobsByCreator(username);
    }
    // === Admin endpoints ===
    @http:ResourceConfig {
        auth: [{ jwtValidatorConfig: validatorConfig, scopes: ["admin"] }]
    }
    isolated resource function get hello(@http:Header string Authorization) returns string|error {
        string username = check util:get_username_from_BearerToken(Authorization);
        return "Hi " + username + ", this is a secured endpoint only for admins!";
    }
}
