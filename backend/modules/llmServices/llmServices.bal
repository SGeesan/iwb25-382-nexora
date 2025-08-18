import ballerina/io;
import BalService.jobServices as jobs;
import BalService.util;

const string IMAGE_READER_SYSTEM_PROMPT = 
    "You are a CV Image Structuring Agent. Your task is to analyze CV images " +
    "and provide a well-structured output containing all extracted details.";

const string TAG_MATCHER_SYSTEM_PROMPT = 
    "You are a Tag Matching Agent. Given a CV and a predefined list of tags, " +
    "your task is to identify and return the array of tags from the list " +
    "that best match the skills, experience, and details in the CV.";

const string JOB_RANKER_SYSTEM_PROMPT = 
    "You are a Job Ranking Agent. Given a list of jobs and a CV, " +
    "your task is to rank the jobs based on their relevance to the CV."+
    " return the _id's of the jobs sorted by relevance in descending order limiting to max 10 results.";

public isolated function imagesToJsonCV(io:ReadableByteChannel[] images) returns json|error{
    // This function will process the images and convert them to a JSON CV format
    GeminiResponce response = check invokeLLM(system_instruction = IMAGE_READER_SYSTEM_PROMPT,imageInput = images,
    structured = true);
    return response.candidates[0].content.parts[0].text.toJson();
}

public isolated function getMatchingTags(string[] jobTags, json cv) returns error|string[] {
    // This function will compare the job tags with the CV data and return matching tags
    // For now, it returns an empty array
    string input = "CV:\n"+ cv.toString() + "\ntags: \n"+jobTags.toString();
    GeminiResponceSchema outputSchema = {
        'type:"ARRAY",
        items: {'type: "STRING"}};
    GeminiResponce response = check invokeLLM(system_instruction = TAG_MATCHER_SYSTEM_PROMPT, 
    textInput = input, structured = true,
    schema = outputSchema);
    string? res = response.candidates[0].content.parts[0].text;
    if res is string{
        json jsonData = check res.fromJsonString();
        string[] tags = check jsonData.fromJsonWithType();
        return tags;
    }
    return [];    
}

public isolated function rankJobs(jobs:Job[] jobList, json cv) returns jobs:Job[]|error {
    string input = "CV:\n"+ cv.toString() + "\njobs: \n"+ jobList.toString();
    GeminiResponceSchema outputSchema = {
        'type:"ARRAY",
        items: {'type: "STRING"}};
    GeminiResponce response = check invokeLLM(system_instruction = JOB_RANKER_SYSTEM_PROMPT,
    textInput = input, structured = true,
    schema = outputSchema);
    string? res = response.candidates[0].content.parts[0].text;
    jobs:Job[] rankedList = [];
    if res is string {
        io:println("Response from LLM: " + res);
        json jsonData = check res.fromJsonString();
        string[] jobIds = check jsonData.fromJsonWithType();
        foreach string jobId in jobIds {
            jobs:Job? job = check util:getJobByID(jobList, jobId);
            if job is jobs:Job {
                rankedList.push(job);
            } else {
                io:println("Job with ID " + jobId + " not found in the provided list.");
            }
        }
    }
    return rankedList;
}