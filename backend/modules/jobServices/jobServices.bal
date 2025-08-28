import ballerina/http;

configurable string USER_HANDLER_SERVICE_URL = "http://localhost:5000/api";

public isolated function createJob(JobPost newJob, string username) returns http:Response|error {
    json payload = {...newJob,
        "CompanyName": username
    };
    http:Client mongoClient = check new http:Client(USER_HANDLER_SERVICE_URL);
    http:Response response = check mongoClient->/jobs/addNewJob.post(payload);
    return response;
}

public isolated function getAllJobTags() returns string[]|error {
    http:Client mongoClient = check new http:Client(USER_HANDLER_SERVICE_URL);
    Tags tags = check mongoClient->/jobs/getAllTags.get();
    string[] jobTags = tags.tags;
    // Logic to retrieve all jobs
    return jobTags;
}

public isolated function getJobsByTags(string[] tags) returns Job[]|error {
    http:Client mongoClient = check new http:Client(USER_HANDLER_SERVICE_URL);
    if tags.length() == 0 {
        return [];
    }
    json payload = {"tags": tags};
    return check mongoClient->/jobs/getJobsByTags.post(payload);
}

public isolated function getAllJobsByCreator(string username) returns Job[]|error {
    if username == "" {
        return error("Username is required");
    }

    // Initialize the client
    http:Client mongoClient = check new http:Client(USER_HANDLER_SERVICE_URL);

    // Prepare payload to send to the backend
    json payload = { "username": username };

    // Call the backend endpoint to fetch jobs by creator
    Job[] jobs = check mongoClient->/jobs/getAllJobsByCreator.post(payload);

    return jobs;
}

public isolated function deleteJob(string jobId) returns http:Response|error {
    if jobId == "" {
        return error("Job ID is required");
    }

    http:Client mongoClient = check new http:Client(USER_HANDLER_SERVICE_URL);

    // Note: 'id' must match Node.js route param
    http:Response response = check mongoClient->/jobs/deleteJob/[jobId].delete();
    return response;
}