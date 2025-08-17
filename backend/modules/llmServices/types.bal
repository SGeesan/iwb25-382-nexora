type PartsItem record {
    string text?;
    record {
        string mime_type;
        string data;
    } inline_data?; // Optional field for inline data
};

type CandidatesItem record {
    record {PartsItem[] parts;} content;
};

type GeminiResponce record {
    CandidatesItem[] candidates;
};

type GeminiResponceSchema record {|
    string 'type;
    GeminiResponceSchema items?;
    GeminiResponceSchema properties?;
|};