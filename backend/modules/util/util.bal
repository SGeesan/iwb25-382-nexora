import ballerina/http;
import ballerina/jwt;
import ballerina/crypto;
import ballerina/mime;
import BalService.jobServices as jobs;
public isolated function get_username_from_BearerToken(string token,string ISSUER,string AUDIENCE, string CERT_FILE) returns string|error {
    http:JwtValidatorConfig validatorConfig = {
    issuer: ISSUER,
    audience: AUDIENCE,
    signatureConfig: { certFile: CERT_FILE },
    scopeKey: "role"};
    if token.substring(0, 7) != "Bearer " {
        return error("Unauthorized: Invalid Authorization header format");
    }
    string jwtToken = token.substring(7);
    jwt:ListenerJwtAuthProvider provider = new (validatorConfig);
    jwt:Payload payload = check provider.authenticate(jwtToken);
    string? username = payload.sub;
    if username is null {
        return error("Unauthorized: No username found in JWT");
    }
    return username;
}


public isolated function md5Hash(string input) returns string|error {
    byte[] inputBytes = input.toBytes();
    byte[] hashedBytes = crypto:hashMd5(inputBytes);
    return hashedBytes.toBase16();  // hex string
}

public isolated function newPDFEntity(byte[] file, string name, string fileName) returns mime:Entity|error {
    mime:Entity pdfBodyPart = new;
    mime:ContentDisposition contentDisposition = new;
    contentDisposition.name = name;
    contentDisposition.fileName = fileName;
    contentDisposition.disposition = "form-data";
    pdfBodyPart.setByteArray(file);
    pdfBodyPart.setContentDisposition(contentDisposition);
    check pdfBodyPart.setContentType(mime:APPLICATION_PDF);
    return pdfBodyPart;
}

public isolated function newImageEntity(byte[] image,string name, string fileName) returns mime:Entity|error {
    mime:Entity pdfBodyPart = new;
    mime:ContentDisposition contentDisposition = new;
    contentDisposition.name = name;
    contentDisposition.fileName = fileName;
    contentDisposition.disposition = "form-data";
    pdfBodyPart.setByteArray(image);
    pdfBodyPart.setContentDisposition(contentDisposition);
    check pdfBodyPart.setContentType(mime:IMAGE_JPEG);
    return pdfBodyPart;
}

public isolated function getJobByID(jobs:Job[] jobList, string jobId) returns jobs:Job|error {
    foreach jobs:Job job in jobList {
        if job._id == jobId {
            return job;
        }
    }
    return error("Job with ID " + jobId + " not found in the provided list.");
}