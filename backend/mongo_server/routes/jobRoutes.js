import express from "express";
import { getJobsByTags, addNewJob, getAllTags, getAllJobsByCreator, deleteJob } from "../controllers/jobController.js";

const router = express.Router();
// Route to get jobs by tags
router.post("/getJobsByTags", getJobsByTags);
// Route to add a new job
router.post("/addNewJob", addNewJob);
// Route to get all tags
router.get("/getAllTags", getAllTags);



router.post("/getAllJobsByCreator", getAllJobsByCreator); // fetch all jobs by user
router.delete("/deleteJob/:id", deleteJob);                // delete a job by ID

export default router;