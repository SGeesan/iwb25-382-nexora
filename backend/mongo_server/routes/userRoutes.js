import express from "express";
import { registerUser, getUserByUserName, getUserByEmail } from "../controllers/userController.js";

const router = express.Router();

router.post("/registerUser", registerUser);

router.get("/getByUserName", getUserByUserName);
router.get("/getByEmail", getUserByEmail);

export default router;
