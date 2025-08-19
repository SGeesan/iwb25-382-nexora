import express from "express";
import { getJobsByTags, addNewJob, getAllTags} from "../controllers/jobController.js";

const router = express.Router();
// Route to get jobs by tags
router.post("/getJobsByTags", getJobsByTags);
// Route to add a new job
router.post("/addNewJob", addNewJob);
// Route to get all tags
router.get("/getAllTags", getAllTags);
export default router;