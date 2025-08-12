import User from "../models/User.js";

export const registerUser = async (req, res) => {
  const { user_name, email, role, password } = req.body;

  try {
    let user = await User.findOne({ email });
    if (user) return res.status(400).json({ message: "email already exists" });

    user = await User.findOne({ user_name });
    if (user) return res.status(400).json({ message: "user_name already exists" });

    user = await User.create({ user_name, email, role, password });

    // Send response
    res.status(200).json({ message: "User created successfully" });

  } catch (error) {
    console.error("Login Error:", error);
    res.status(500).json({ message: `Internal server error ${error.message}` });
  }
};



export const getUserByUserName = async (req, res) => {
  const { user_name } = req.query;

  try {
    // Check if user exists
    const user = await User.findOne({ user_name });
    if (!user) return res.status(400).json({ message: "User not found" });

    // Send response
    res.status(200).json({
        user_name: user.user_name,
        email: user.email,
        role: user.role,
        password: user.password,
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ message: `Internal server error ${error.message}` });
  }
};


export const getUserByEmail = async (req, res) => {
  const { email } = req.query;

  console.log(email);

  try {
    // Check if user exists
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ message: "User not found" });

    // Send response
    res.status(200).json({
        user_name: user.user_name,
        email: user.email,
        role: user.role,
        password: user.password,
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ message: `Internal server error ${error.message}` });
  }
};