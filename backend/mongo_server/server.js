import express from "express";
import dotenv from "dotenv";
import connectDB from "./config/db.js";
import userRoutes from "./routes/userRoutes.js";
import jobRoutes from "./routes/jobRoutes.js";
import cors from "cors";
import morgan from "morgan";

dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());
app.use(morgan("dev"));

app.use("/api/user", userRoutes);
app.use("/api/jobs", jobRoutes);

const startServer = async () => {
  try {
    await connectDB(); // Wait for the database connection to be established
    const PORT = process.env.PORT || 5000; // Define PORT here
    app.listen(PORT, () =>
      console.log(`Server running on http://localhost:${PORT}`) // Corrected template literal
    );
  } catch (error) {
    console.error("Failed to connect to database or start server:", error);
    process.exit(1); // Exit if connection or server startup fails
  }
};

startServer();
