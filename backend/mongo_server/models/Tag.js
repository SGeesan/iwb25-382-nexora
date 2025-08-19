import mongoose from "mongoose";

const tagSchema = new mongoose.Schema(
    {
      tags: {
        technical: {
          type: [String],
          default: [],
        },
        office: {
          type: [String],
          default: [],
        },
        mechanical: {
          type: [String],
          default: [],
        },
        management: {
          type: [String],
          default: [],
        },
        soft_skills: {
          type: [String],
          default: [],
        },
        finance: {
          type: [String],
          default: [],
        },
        design: {
          type: [String],
          default: [],
        },
      },
    },
    { collection: "Tags" }
  );

export default mongoose.model("Tags", tagSchema, "Tags");
