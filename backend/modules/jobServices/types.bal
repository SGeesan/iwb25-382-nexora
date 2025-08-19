public type Job record {|
    string _id;
    string JobTitle;
    string JobDescription;
    string CompanyName;
    string[] JobTags;
|};

public type JobPost record {|
    string JobTitle;
    string JobDescription;
    string[] JobTags;
|};

type Tags record {
    string[] tags;
};