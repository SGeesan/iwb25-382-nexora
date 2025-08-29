import mongoose from "mongoose";

const companyRequestSchema = new mongoose.Schema(
  {
    company_name: { type: String, required: true },
    file_uuid: { type: String, required: true },
    status: { type: String, enum: ["pending", "approved", "rejected"], default: "pending" }
  },
  { 
    timestamps: true, 
    collection: "CompanyRequests"
  }
);

export default mongoose.model("CompanyRequests", companyRequestSchema, "CompanyRequests");
