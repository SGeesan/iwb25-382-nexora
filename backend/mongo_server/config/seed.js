import mongoose from "mongoose";
import dotenv from "dotenv";
import Tag from "../models/Tag.js";

dotenv.config();

async function seed() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log("MongoDB connected");

    // Predefined Tags document
    const defaultTags = {
      tags: {
        technical: [
          "Node.js","Express.js","React","Vue.js","Angular","Next.js","JavaScript",
          "TypeScript","Python","Django","Flask","FastAPI","Java","Spring Boot","C",
          "C++","C#",".NET Core","PHP","Laravel","Ruby on Rails","Go","Rust","SQL",
          "MySQL","PostgreSQL","MongoDB","Redis","GraphQL","REST","gRPC","Docker",
          "Kubernetes","Terraform","Ansible","Linux","Bash","Git","GitHub","CI/CD",
          "AWS","Azure","Google Cloud","Firebase","TensorFlow","PyTorch","Scikit-learn",
          "Machine Learning","Deep Learning","Data Science","NLP"
        ],
        office: [
          "Microsoft Word","Microsoft Excel","Microsoft PowerPoint","Microsoft Outlook",
          "Microsoft Teams","Google Docs","Google Sheets","Google Slides","Google Drive",
          "Slack","Zoom","Trello","Asana","Notion","Jira","Confluence","Calendar Management",
          "Email Management","Data Entry","Typing","Time Management","Scheduling",
          "Record Keeping","Reporting","Presentation Design"
        ],
        mechanical: [
          "AutoCAD","SolidWorks","CATIA","Fusion 360","ANSYS","MATLAB","CNC Machining",
          "3D Printing","HVAC Systems","Thermodynamics","Fluid Mechanics","Robotics",
          "Mechatronics","Manufacturing","Welding","Sheet Metal Design","Injection Molding",
          "Quality Control","Pneumatics","Hydraulics","Control Systems","Engineering Drawing",
          "Maintenance","Product Design","Failure Analysis","Industrial Safety"
        ],
        management: [
          "Agile","Scrum","Kanban","Lean","Six Sigma","PMP","Stakeholder Management",
          "Project Planning","Risk Management","Budgeting","Leadership","Negotiation",
          "Team Management","Business Analysis","Strategic Planning","OKRs","KPIs",
          "Change Management","Resource Allocation","Decision Making"
        ],
        soft_skills: [
          "Communication","Collaboration","Problem Solving","Critical Thinking",
          "Adaptability","Creativity","Leadership","Work Ethic","Emotional Intelligence",
          "Conflict Resolution","Teamwork","Networking","Active Listening","Public Speaking",
          "Time Management","Stress Management","Patience","Decision Making","Mentoring",
          "Persuasion"
        ],
        finance: [
          "Accounting","Bookkeeping","Financial Analysis","Budgeting","Forecasting","Taxation",
          "Auditing","Payroll Management","Cost Accounting","Investment Analysis","Risk Assessment",
          "Banking Operations","SAP FICO","QuickBooks","ERP Systems"
        ],
        design: [
          "UI/UX Design","Graphic Design","Adobe Photoshop","Adobe Illustrator","Adobe XD","Figma",
          "Sketch","Canva","Prototyping","Wireframing","User Research","Interaction Design",
          "Motion Graphics","3D Modeling","Video Editing","Branding","Typography","Color Theory"
        ]
      },Name: "TAG_MAIN"};

    // Insert or overwrite the TAG_MAIN document
    const existing = await Tag.findOne({ Name: "TAG_MAIN" });

    if (!existing) {
      await Tag.create(defaultTags);
      console.log("TAG_MAIN seeded");
    } else {
      await Tag.updateOne({ Name: "TAG_MAIN" }, defaultTags);
      console.log("TAG_MAIN updated");
    }

    // ✅ Gracefully close connection
    await mongoose.disconnect();
    console.log("MongoDB disconnected, seeding complete");
  } catch (err) {
    console.error("Seeding error:", err);
    process.exit(1); // only force-exit on error
  }
}

seed();
