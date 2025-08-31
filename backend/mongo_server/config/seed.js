import mongoose from "mongoose";
import dotenv from "dotenv";
import Tag from "../models/Tag.js";
import User from "../models/User.js";
import Jobs from "../models/Job.js";
import crypto from "crypto";

dotenv.config();

function md5Hash(password) {
  return crypto.createHash("md5").update(password).digest("hex");
}

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

    const users = [
      {
        user_name: "AdminUser",
        email: process.env.ADMIN_EMAIL,
        role: "admin",
        password: process.env.ADMIN_PASSWORD,
      },
      {
        user_name: "Nexora",
        email: "company@example.com",
        role: "company",
        password: "company123",
      },
    ];

    for (const u of users) {
      const hashedPassword = md5Hash(u.password);
      const existing = await User.findOne({ email: u.email });

      if (!existing) {
        await User.create({ ...u, password: hashedPassword });
        console.log(`Created user: ${u.user_name}`);
      } else {
        await User.updateOne({ email: u.email }, { ...u, password: hashedPassword });
        console.log(`Updated user: ${u.user_name}`);
      }
    }

    const jobs = [
      {
        JobTitle: "Frontend Developer",
        JobDescription: "Develop modern web applications using React, Vue, or Angular.",
        CompanyName: "Nexora",
        JobTags: ["JavaScript", "React", "UI/UX"]
      },
      {
        JobTitle: "Backend Developer",
        JobDescription: "Build APIs and manage server-side logic using Node.js or Python.",
        CompanyName: "Nexora",
        JobTags: ["Node.js", "Python", "REST"]
      },
      {
        JobTitle: "Data Analyst",
        JobDescription: "Analyze data and generate reports to support business decisions.",
        CompanyName: "Nexora",
        JobTags: ["Data Science", "SQL", "Excel"]
      },
      {
        JobTitle: "DevOps Engineer",
        JobDescription: "Maintain cloud infrastructure and CI/CD pipelines.",
        CompanyName: "Nexora",
        JobTags: ["Docker", "Kubernetes", "AWS", "CI/CD"]
      },
      {
        JobTitle: "Machine Learning Engineer",
        JobDescription: "Design and implement machine learning models.",
        CompanyName: "Nexora",
        JobTags: ["Python", "TensorFlow", "PyTorch", "Machine Learning"]
      },
      {
        JobTitle: "UI/UX Designer",
        JobDescription: "Create engaging user interfaces and experiences.",
        CompanyName: "Nexora",
        JobTags: ["UI/UX Design", "Figma", "Prototyping", "Wireframing"]
      },
      {
        JobTitle: "Finance Analyst",
        JobDescription: "Manage financial reporting, budgeting, and forecasting.",
        CompanyName: "Nexora",
        JobTags: ["Accounting", "Budgeting", "Financial Analysis", "Excel"]
      },
      {
        JobTitle: "Project Manager",
        JobDescription: "Plan, execute, and oversee projects using Agile methodology.",
        CompanyName: "Nexora",
        JobTags: ["Agile", "Scrum", "Leadership", "Project Planning"]
      },
      {
        JobTitle: "Content Writer",
        JobDescription: "Create engaging content for marketing and communication.",
        CompanyName: "Nexora",
        JobTags: ["Communication", "Creativity", "Time Management", "Public Speaking"]
      },
      {
        JobTitle: "Mechanical Engineer",
        JobDescription: "Design and maintain mechanical systems and equipment.",
        CompanyName: "Nexora",
        JobTags: ["AutoCAD", "SolidWorks", "HVAC Systems", "Maintenance"]
      }
    ];    

    for (const j of jobs) {
      const existingJob = await Jobs.findOne({ JobTitle: j.JobTitle, CompanyName: j.CompanyName });
      if (!existingJob) {
        await Jobs.create(j);
        console.log(`Created job: ${j.JobTitle}`);
      } else {
        await Jobs.updateOne(
          { JobTitle: j.JobTitle, CompanyName: j.CompanyName },
          j
        );
        console.log(`Updated job: ${j.JobTitle}`);
      }
    }

    // Gracefully close connection
    await mongoose.disconnect();
    console.log("MongoDB disconnected, seeding complete");
  } catch (err) {
    console.error("Seeding error:", err);
    process.exit(1); // only force-exit on error
  }
}

seed();
