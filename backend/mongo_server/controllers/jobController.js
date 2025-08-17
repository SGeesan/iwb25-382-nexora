import Job from "../models/Job.js";
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
