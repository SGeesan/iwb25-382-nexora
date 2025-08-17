import ballerina/http;
import ballerina/io;
import ballerina/mime;

configurable string USER_HANDLER_SERVICE_URL = "http://localhost:5000/api";
configurable string FILE_HANDLER_SERVICE_URL = "http://localhost:8000";

type ImageInfo record {
    int page_count;
    string[] images;
};

isolated function newPDFEntity(byte[] file) returns mime:Entity|error {
    mime:Entity pdfBodyPart = new;
    mime:ContentDisposition contentDisposition = new;
    contentDisposition.name = "pdf";
    contentDisposition.fileName = "CV.pdf";
    contentDisposition.disposition = "form-data";
    pdfBodyPart.setByteArray(file);
    pdfBodyPart.setContentDisposition(contentDisposition);
    check pdfBodyPart.setContentType(mime:APPLICATION_PDF);
    return pdfBodyPart;
}

public isolated function uploadFile(byte[] file, string username) returns http:Response|error {
    // This function is a placeholder for the file upload logic
    // It should handle the file upload process, save the file, and return an appropriate response
    http:Client fileClient = check new (FILE_HANDLER_SERVICE_URL,httpVersion = "1.1");
    
    // Creat Multipart request with PDF file
    mime:Entity pdfBodyPart = check newPDFEntity(file);
    mime:Entity[] parts= [pdfBodyPart];
    http:Request request = new;
    request.setBodyParts(parts);

    json uuidJson = check fileClient->/upload.post(request);
    string uuid = check uuidJson.uuid; 
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
    string uuid = check result.uuid;
    // io:println(uuid);
    http:Client fileClient = check new (FILE_HANDLER_SERVICE_URL,httpVersion = "1.1");
    ImageInfo info = check fileClient->get("/pdf/"+uuid);
    io:println(info.images);
    io:ReadableByteChannel[] images = [];
    foreach string path in info.images {
        io:println("call the endpoint:", path);
        http:Response response = check fileClient->get(path);
        byte[] imageBytes = check response.getBinaryPayload();
        images.push(check io:createReadableChannel(imageBytes));
    }
    return images;
}