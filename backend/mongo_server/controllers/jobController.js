import Job from "../models/Job.js";
import Tag from "../models/Tag.js";

export const getJobsByTags = async (req, res) => {
   const tags = req.body.tags;
   try {
       const jobs = await Job.find({ JobTags: { $in: tags } });
       res.status(200).json(jobs);
   } catch (error) {
       res.status(500).json({ message: error.message });
   }
};

export const addNewJob = async (req, res) => {
   const jobData = req.body;
   const newJob = new Job(jobData);
   try {
       const savedJob = await newJob.save();
       res.status(201).json({"_id":savedJob._id});
   } catch (error) {
       res.status(500).json({ message: error.message });
   }
};

export const getAllTags = async (req, res) => {
    try {
      // Assuming you have only ONE Tag document that holds all tags
      const tagDoc = await Tag.findOne();
  
      if (!tagDoc) {
        return res.status(404).json({ message: "No tags found" });
      }
  
      // Merge all tag arrays into a single array
      const allTags = [
        ...tagDoc.tags.technical,
        ...tagDoc.tags.office,
        ...tagDoc.tags.mechanical,
        ...tagDoc.tags.management,
        ...tagDoc.tags.soft_skills,
        ...tagDoc.tags.finance,
        ...tagDoc.tags.design,
      ];
  
      res.status(200).json({ tags: allTags });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  };
  