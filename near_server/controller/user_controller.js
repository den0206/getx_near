const User = require('../model/user');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

async function signUp(req, res) {
  const body = req.body;
  const isFind = await User.findOne({email: body.email});
  const salt = process.env.SALT_OR_ROUNDS;

  if (isFind)
    return res
      .status(400)
      .json({status: false, message: 'Already Email Exist'});

  try {
    const hashed = await bcrypt.hash(body.password, parseInt(salt));

    let user = new User({
      name: body.name,
      email: body.email,
      password: hashed,
    });

    await user.save();
    res.status(200).json({status: true, data: user});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

async function login(req, res) {
  const email = req.body.email;
  const password = req.body.password;

  try {
    const user = await User.findOne({email: email});
    if (!user)
      return res.status(400).json({status: false, message: 'No  Exist Email'});

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid)
      return res
        .status(400)
        .json({status: false, message: 'Password not match'});

    const secret = process.env.JWT_SECRET_KEY || 'mysecretkey';
    const expiresIn = process.env.JWT_EXPIRES_IN;
    console.log(expiresIn);

    const payload = {userId: user.id, email: user.email};
    const token = jwt.sign(payload, secret, {
      expiresIn: expiresIn,
    });

    const r = {user, token};
    res.status(200).json({status: true, data: r});
  } catch (e) {
    res.status(500).json({status: false, message: e.message});
  }
}

module.exports = {signUp, login};
