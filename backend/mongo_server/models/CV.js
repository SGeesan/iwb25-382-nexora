import mongoose from "mongoose";

const cvSchema = new mongoose.Schema(
  {
    user_name : { type: String, required: true },
    file_uuid : { type: String, required: true }
  },
  { 
    timestamps: true, 
    collection: "CVs"
  }
);

export default mongoose.model("CVs", cvSchema, "CVs");