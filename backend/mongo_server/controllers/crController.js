import CompanyRequest from "../models/CompanyRequest.js";

// Add or update a company request (upsert style, like CV controller)
export const addCompanyRequest = async (req, res) => {
  const { company_name, file_uuid } = req.body;

  try {
    let request = await CompanyRequest.findOne({ company_name });

    if (request) {
      request.file_uuid = file_uuid;
      await request.save(); // runs full validators
    } else {
      request = await CompanyRequest.create({ company_name, file_uuid });
    }

    res.status(201).json({ _id: request._id });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get request by company name
export const getCompanyRequestByName = async (req, res) => {
  const { company_name } = req.query;

  try {
    const request = await CompanyRequest.findOne({ company_name });
    if (!request) {
      return res.status(404).json({ message: "Company request not found" });
    }
    res.status(200).json(request);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update request status
export const updateCompanyRequestStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body; // "pending", "approved", "rejected"

  try {
    const updatedRequest = await CompanyRequest.findByIdAndUpdate(
      id,
      { $set: { status } },
      { new: true, runValidators: true }
    );

    if (!updatedRequest) {
      return res.status(404).json({ message: "Company request not found" });
    }

    res.status(200).json(updatedRequest);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get all company requests
export const getAllCompanyRequests = async (req, res) => {
  try {
    const requests = await CompanyRequest.find().sort({ createdAt: -1 }); // latest first
    res.status(200).json(requests);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};