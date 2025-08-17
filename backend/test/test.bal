import ballerina/io;
public function main() returns error? {
    json some = {"game":"witcher","version":"2"};
    string game = check some.name;
    io:print(game);
}