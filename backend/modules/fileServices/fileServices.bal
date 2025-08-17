import ballerina/http;
import ballerina/io;

configurable string USER_HANDLER_SERVICE_URL = "http://localhost:5000/api";

public isolated function uploadFile(stream<byte[], io:Error?> file, string username) returns http:Response|error {
    // This function is a placeholder for the file upload logic
    // It should handle the file upload process, save the file, and return an appropriate response
    io:println("File upload initiated for user: ", username);
    
    string uuid = "12345"; // This should be replaced with actual UUID generation logic
    http:Client mongoClient = check new (USER_HANDLER_SERVICE_URL);
    json fileData = {
        "user_name": username,
        "file_uuid": uuid
    };
    http:Response response = check mongoClient->/cv/addNewCV.post(fileData);
    return response;
}

public isolated function getCVasImages(string username) returns io:ReadableByteChannel[]|error {
    // This function is a placeholder for retrieving CVs as images
    // It should return a stream of images associated with the user's CV
    http:Client mongoClient = check new (USER_HANDLER_SERVICE_URL);
    json result = check mongoClient->/cv/getCV.get(params = { "user_name": username });
    io:println(result.uuid);
    
    string[] imagePaths = [];
    io:ReadableByteChannel[] images = [];
    foreach string path in imagePaths {
        //io:ReadableByteChannel imageChannel = check io:ReadableByteChannel;
        //images.push(imageChannel);
    }
    return images;
}