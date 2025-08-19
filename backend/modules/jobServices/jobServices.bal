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
    Job[] jobs = [
        {
            "_id": "J001",
            "JobTitle": "Backend Developer",
            "JobDescription": "Build and maintain server-side applications, ensuring high performance and responsiveness.",
            "CompanyName": "CodeSphere Technologies",
            "JobTags": ["Node.js", "Express", "MongoDB", "API Development"]
        },
        {
            "_id": "J002",
            "JobTitle": "Machine Learning Engineer",
            "JobDescription": "Design, train, and deploy machine learning models for real-world applications.",
            "CompanyName": "DataVision Labs",
            "JobTags": ["Python", "TensorFlow", "Data Science", "Model Deployment"]
        }
    ];
    // Logic to retrieve all job creators
    return jobs;
}
