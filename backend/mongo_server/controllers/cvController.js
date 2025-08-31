import CV from "../models/CV.js";
export const addNewCV = async (req, res) => {
  const { user_name, file_uuid } = req.body;

  try {
    const savedCV = await CV.findOneAndUpdate(
      { user_name },                       // find by username
      { $set: { file_uuid } },             // update file_uuid
      { new: true, upsert: true }          // return updated doc, create if not exists
    );

    res.status(201).json({ "_id": savedCV._id });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getCVByUsername = async (req, res) => {
    const {user_name} = req.query;
    try {
        console.log("Fetching CV for user:", user_name);
        const cv = await CV.findOne({ user_name: user_name });
        if (!cv) {
            return res.status(404).json({ message: "CV not found" });
        }
        res.status(200).json({"uuid":cv.file_uuid});
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}