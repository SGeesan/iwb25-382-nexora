import express from "express";
import { 
  addCompanyRequest, 
  getCompanyRequestByName, 
  updateCompanyRequestStatus,
  getAllCompanyRequests
} from "../controllers/crController.js";

const router = express.Router();

// Add or update a company request
router.post("/addCompanyRequest", addCompanyRequest);

// Get all company requests
router.get("/getAllCompanyRequests", getAllCompanyRequests);

// Get a company request by company_name
router.get("/getCompanyRequest", getCompanyRequestByName);

// Update request status by ID
router.put("/updateCompanyRequestStatus/:id", updateCompanyRequestStatus);

export default router;
