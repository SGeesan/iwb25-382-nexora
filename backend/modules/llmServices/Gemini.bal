import ballerina/http;
import ballerina/io;
import ballerina/mime;

configurable string GOOGLE_API_KEY = ?;

const string DEFAULT_INSTRUCTION = "You are a helpful assistant. Answer the question based on the provided content.";

public isolated function invokeLLM(io:ReadableByteChannel[]? imageInput=(), string? textInput=(), string system_instruction=DEFAULT_INSTRUCTION,
 boolean structured=false, GeminiResponceSchema? schema=()) returns GeminiResponce|error {
    string url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
    http:Client geminiClient = check new (url);
    map<string|string[]> Headers = {"X-goog-api-key": GOOGLE_API_KEY};

    PartsItem[] querryParts = [];

    if imageInput is io:ReadableByteChannel[] {
        foreach io:ReadableByteChannel channel in imageInput {
            byte[] image = check channel.readAll();
            string imageEncoded = image.toBase64();
            io:println("image has bytes:",imageEncoded.length());
            querryParts.push({
                "inline_data": {
                    "mime_type": mime:IMAGE_JPEG,
                    "data": imageEncoded
                }
            });
        }
    }
    if textInput is string {
        querryParts.push({
            "text": textInput
        });
    }
    if querryParts.length() == 0 {
        return error("No input provided for the LLM");
    }
    json payload = {
        "system_instruction": {
            "parts": [
                {
                    "text": system_instruction
                }
            ]
        },
        "contents": [
            {
                "parts": querryParts.toJson()
            }
        ]
    };
    
    if structured{
        json genConfig = {"responseMimeType": "application/json"};
        if schema is GeminiResponceSchema{
            genConfig = check genConfig.mergeJson({"responseSchema": schema});
        }
        payload = check payload.mergeJson({
            "generationConfig": genConfig
        });
    }
    return check geminiClient->/.post(payload, Headers);
}
