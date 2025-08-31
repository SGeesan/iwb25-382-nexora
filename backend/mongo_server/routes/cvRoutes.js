import express from "express";
import { addNewCV,getCVByUsername } from '../controllers/cvController.js';

const router = express.Router();
// Route for adding CV
router.post('/addNewCV', addNewCV);
router.get('/getCV', getCVByUsername);

export default router;
