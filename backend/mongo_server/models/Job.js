import mongoose from "mongoose";

const jobSchema = new mongoose.Schema(
  {
    JobTitle: { type: String, required: true },
    JobDescription: { type: String, required: true },
    CompanyName: { type: String, required: true },
    JobTags: { type: [String], default: [] }
  },
  { 
    timestamps: true, 
    collection: "Jobs"
  }
);

export default mongoose.model("Jobs", jobSchema, "Jobs");
