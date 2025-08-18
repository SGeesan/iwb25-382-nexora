import ballerina/io;
import BalService.jobServices as jobs;

const string IMAGE_READER_SYSTEM_PROMPT = 
    "You are a CV Image Structuring Agent. Your task is to analyze CV images " +
    "and provide a well-structured output containing all extracted details.";

const string TAG_MATCHER_SYSTEM_PROMPT = 
    "You are a Tag Matching Agent. Given a CV and a predefined list of tags, " +
    "your task is to identify and return the array of tags from the list " +
    "that best match the skills, experience, and details in the CV.";

public isolated function imagesToJsonCV(io:ReadableByteChannel[] images) returns json|error{
    // This function will process the images and convert them to a JSON CV format
    GeminiResponce response = check invokeLLM(system_instruction = IMAGE_READER_SYSTEM_PROMPT,imageInput = images,
    structured = true);
    return response.candidates[0].content.parts[0].text.toJson();
}

public isolated function getMatchingTags(string[] jobTags, json cv) returns error|string[] {
    // This function will compare the job tags with the CV data and return matching tags
    // For now, it returns an empty array
    string input = string `CV:
${cv.toString()}
tags: 
${jobTags.toString()}
`;
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

public isolated function rankJobs(jobs:Job[] jobList, json cv) returns jobs:Job[] {
    // This function will rank the jobs based on the CV data
    // For now, it returns the jobs as is
    return jobList;
}