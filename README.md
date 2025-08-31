# MatchCV - Automated CV Matching & Job Management Platform

MatchCV is a full-stack application with Node.js, Python, and Ballerina backend services, along with a modern frontend, designed to help users find the right jobs based on their skills, qualifications, and experience, while allowing companies to manage users, job postings, and CV matching efficiently.

## Table of Contents

- [Project Setup](#project-setup)
- [Node Service](#node-service)
- [Python Service](#python-service)
- [Ballerina Service](#ballerina-service)
- [Frontend](#frontend)
- [Usage](#usage)
- [Notes](#notes)

## Project Setup

### Node Service Setup

1. Install Node.js

Ensure that Node.js (LTS version recommended) is installed on your system. You can download it from the official Node.js website (https://nodejs.org/)

2. Set up MongoDB

Make sure MongoDB is running, either as a local instance or using a cloud-hosted database (e.g., MongoDB Atlas). You can download MongoDB from the official website (https://www.mongodb.com/try/download/community).

Navigate to the backend MongoDB service:
```bash
cd backend/mongo_server/
```

Create a `.env` file in the `backend/mongo_server/` directory (refer to `.env.example`) and make sure you add the corresponding URI for the MongoDB initialized above. Additionally, set your desired `ADMIN_EMAIL` and `ADMIN_PASSWORD` values which can be used to sign in as admin to the system.

Install dependencies and seed the database:
```bash
npm install
npm run seed
npm start
```

### Python Service Setup

1. Install Python

Ensure that Python (version 3.7 or higher recommended) is installed on your system. You can download it from the official Python website (https://www.python.org/downloads/)

2. Install Poppler:
   - **Linux**: 
     ```bash
     sudo apt-get install python-poppler
     ```
   - **Windows**: 
     - Download Poppler from https://github.com/oschwartz10612/poppler-windows/releases/tag/v24.08.0-0
     - Unzip the downloaded file
     - Add the `bin` folder to your system PATH

Navigate to the PDF service:
```bash
cd backend/pdf_server
```

Create a virtual environment, activate it, and install dependencies:
```bash
python -m venv venv
venv\Scripts\activate  # Windows
# or
source venv/bin/activate  # Linux/macOS
pip install -r requirements.txt
```

Run the Python service:
```bash
python main.py
```

### Ballerina Service Setup

1. **Install Ballerina Swan Lake**

   Download and install Ballerina from the official website (https://ballerina.io/downloads/)

2. **Obtain your Gemini API Key**

   Get your Gemini API key from Google AI Studio (https://aistudio.google.com/)

3. **Create Config.toml**

   Create `Config.toml` in the `backend/` directory (refer to `Config.example.toml`) and add the obtained Google API key.

4. **Run the service:**
   ```bash
   cd backend
   bal run
   ```

### Frontend Setup

1. Navigate to the frontend folder:
```bash
cd frontend
```

2. Install dependencies and start the development server:
```bash
npm install
npm run dev
```

3. Open the frontend in your browser using the localhost port displayed in the terminal.

## Usage

### Company Flow
1. **Sign up** as a company.
2. **Login** to the company dashboard.
3. **Submit verification documents**.
   - Companies cannot post jobs until verified by an admin.
4. **Await verification**.
   - Admins review submitted documents and approve or reject the company.
5. **Post jobs** once verified.

### Admin Flow
1. **Login** using pre-configured credentials (set during [Node Service Setup](#node-service-setup) in the `.env` file).
2. **Review verification requests** from companies.
3. **Approve or reject** company verification submissions.

### User Flow
1. **Sign up** as a user.
2. **Login** to the platform.
3. **Upload CV** to showcase skills and qualifications.
4. **Search for jobs**.
   - Users receive filtered and ranked job listings based on their CV and skills using AI-powered matching.

## Notes

- Make sure all services are running simultaneously for full functionality.
- Seed scripts populate default data for users, tags, and jobs.
- Use `main.bat` (Windows) for Python setup automation if desired.
