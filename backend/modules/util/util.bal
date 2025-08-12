import ballerina/http;
import ballerina/jwt;
import ballerina/crypto;
configurable string ISSUER = "nexora";
configurable string AUDIENCE = "client";
configurable string CERT_FILE = "./resource/alice.crt";
configurable string PRIVATE_KEY_FILE = "./resource/alice.key";
public isolated function get_username_from_BearerToken(string token) returns string|error {
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