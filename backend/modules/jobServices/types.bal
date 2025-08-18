public type Job record {|
    string _id;
    string JobTitle;
    string JobDescription;
    string CompanyName;
    string CreatedBy;
    string[] JobTags;
|};

public type JobPost record {|
    string JobTitle;
    string JobDescription;
    string CompanyName;
    string[] JobTags;
|};