public type User record {
    string user_name;
    string email;
    string role;
    string password;
};

public type CompanyRequest record {
    string _id;
    string company_name;
    string file_uuid;
    string status;
};