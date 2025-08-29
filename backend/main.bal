import BalService.authServices as auth;
import BalService.fileServices as file;
import BalService.jobServices as jobs;
import BalService.llmServices as llm;
import BalService.util;

import ballerina/http;
import ballerina/io;

configurable int PORT = 9090;
listener http:Listener mainListner = new (PORT);

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
    signatureConfig: {certFile: CERT_FILE},
    scopeKey: "role"
};

// ===== Global CORS applied to the whole service =====
@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173"], // your Vue app URL
        allowCredentials: true,
        allowHeaders: ["Content-Type", "Authorization"],
        exposeHeaders: ["Content-Type", "Authorization"],
        allowMethods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
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
    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["user"]}]
    }
    isolated resource function post user/upload_cv(@http:Header string Authorization, http:Request request) returns http:Response|error {
        // This endpoint allows users to upload their CVs
        string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        byte[] bytes = check request.getBinaryPayload();
        return file:uploadCV(bytes, username);
    }

    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["user"]}]
    }
    isolated resource function get user/get_cv_info(@http:Header string Authorization) returns file:ImageInfo|error {
        // This endpoint allows users to get their CV UUID
        string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        return file:getCVInfo(username);
    }

    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["user"]}]
    }
    isolated resource function get user/get_cv_image(string path) returns http:Response|error {
        //@http:Header string Authorization
        //string username = check util:get_username_from_BearerToken(Authorization);
        // Add a security check here to ensure the user has access to this CV image
        return file:getImage(path);
    }


    isolated resource function get user/search_jobs(@http:Header string Authorization) returns jobs:Job[]|http:NotFound|error {
        // This endpoint allows users to search for jobs
        string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        
        io:print("Searching jobs for user: ", username, "\n");

        // PDF -> images
        io:ReadableByteChannel[] images = check file:getPDFasImages(username);
        if images.length() == 0 {
            http:NotFound notFoundResponse = {body: "No CVs found for the user"};
            return notFoundResponse;
        }

        // Process images to extract json data
        json cv = check llm:imagesToJsonCV(images);

        // Get all job tags in the system
        string[] allJobTags = check jobs:getAllJobTags();
        
        // Get all job tags that match the CV data
        string[] matchingTags = check llm:getMatchingTags(allJobTags,cv);

        // Get the jobs from matched tags
        jobs:Job[] matchedJobs = check jobs:getJobsByTags(matchingTags);

        // Rank the jobs based on the CV data
        jobs:Job[] rankedJobs = check llm:rankJobs(matchedJobs, cv);

        return rankedJobs;
    }

    // ==== Company endpoints ====
    isolated resource function post company/upload_request(@http:Header string Authorization, http:Request request) returns http:Response|error {
        // This endpoint allows users to upload their CVs
        string company_name = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        byte[] bytes = check request.getBinaryPayload();
        return file:uploadReqDoc(bytes, company_name);
    }

    isolated resource function get company/get_cr_status(@http:Header string Authorization) returns auth:CompanyRequest|error {
        // This endpoint allows users to get their CV UUID
        string company_name = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        return auth:getCompanyRequest(company_name);
    }
    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["company"]}]
    }
    isolated resource function post company/create_job(@http:Header string Authorization, jobs:JobPost newJob) returns http:Response|error {
        // This endpoint allows companies to create jobs
        string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        return jobs:createJob(newJob, username);
    }
    

    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["company"]}]
    }
    isolated resource function post company/delete_job(@http:Header string Authorization, @http:Payload json payload) returns http:Response|error {
        // string username = check util:get_username_from_BearerToken(Authorization);
        
        // Extract jobId from the payload
        string jobId = check payload.jobId;
        
        return jobs:deleteJob(jobId);
    }


    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["company"]}]
    }
    isolated resource function get company/get_all_jobs(@http:Header string Authorization) returns jobs:Job[]|error {
        // This endpoint allows users to get all job tags
        string username = check util:get_username_from_BearerToken(Authorization); // Validate JWT and get username
        return jobs:getAllJobsByCreator(username);
    }

    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["company"]}]
    }
    isolated resource function get company/get_all_tags() returns string[]|error {
        // This endpoint allows users to get all job tags
        return jobs:getAllJobTags();
    }

    // === Admin endpoints ===
    @http:ResourceConfig {
        auth: [{jwtValidatorConfig: validatorConfig, scopes: ["admin"]}]
    }
    isolated resource function get hello(@http:Header string Authorization) returns string|error {
        string username = check util:get_username_from_BearerToken(Authorization);
        return "Hi " + username + ", this is a secured endpoint only for admins!";
    }

    isolated resource function get admin/get_all_company_requests() returns auth:CompanyRequest[]|error {
        return auth:getAllCompanyRequests();
    }

    isolated resource function get admin/get_company_request_doc/[string company_name]() returns file:ImageInfo|error{
        return file:getdocInfo(company_name);
    }

    isolated resource function get admin/get_cr_image(string path) returns http:Response|error {
        //@http:Header string Authorization
        //string username = check util:get_username_from_BearerToken(Authorization);
        // Add a security check here to ensure the user has access to this CV image
        return file:getImage(path);
    }

    isolated resource function put admin/update_company_request_status/[string _id](map<json> payload) returns http:Response|error {
    json status = check payload.new_status;
    string new_status = status.toString();
    return auth:updateCompanyRequestStatus(_id,new_status);
    }
}
