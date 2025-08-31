import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    user_name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    role: { type: String, required: true},
    password: { type: String, required: true },
  },
  { 
    timestamps: true, 
    collection: "Users"
  }
);

export default mongoose.model("User", userSchema, "Users");
