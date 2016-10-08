import request from 'request'
import User from '../model/user'
import jwt from 'jsonwebtoken'
import config from '../config/secret'

export function SignUp(req, res) {
  let { email, password } = req.body
  if (!email || !password) {
    return res.status(400).json({
      success: false,
      msg: 'Please enter your email and password.',
    })
  }
  email = email.toLowerCase()
  const user = new User({
    email,
    password,
  })
  user.save((err) => {
    if (err) {
      return	res.status(403).json({
        success: false,
        msg: err,
      })
    }
    const token = jwt.sign({ email: user.email }, config.JwtSecret, {
      expiresIn: 5184000, // 60 days in seconds
    })
    return res.status(201).json({
      success: true,
      user,
      access_token: `JWT ${token}`,
    })
  })
}

export function SignIn(req, res) {
  let { email, password } = req.body
  if (!email || !password) {
    return res.status(400).json({
      success: false,
      msg: 'Please enter your email and password.',
    })
  }
  email = email.toLowerCase()
  User.findOne({ email }, (err, user) => {
    // if error finding an user
    if (err) {
      return res.status(403).json({
        success: false,
        msg: err,
      })
    }
    // if no such user
    if (!user) {
      return res.status(401).json({
        success: false,
        msg: 'Authentication failed. User not found.',
      })
    }
		// Check if password matches
    user.authenticate(password, (err2, isMatch) => {
      if (isMatch) {
      // Create token if the password matched and no error was thrown
        const token = jwt.sign({ email: user.email }, config.JwtSecret, {
          expiresIn: 5184000, // 60 days in seconds
        })
        return res.status(200).json({
          success: true,
          user,
          access_token: `JWT ${token}`,
        })
      }
      return 	res.status(401).json({
        success: false,
        msg: 'Authentication failed. Passwords did not match.',
      })
    })
  })
}

export function Verify(req, res) {
  if (!req.query.method || (req.query.method!= 'email' && req.query.method!= 'text')) {
    return res.status(400).json({
      success: false,
      msg: 'ERROR: Missing parameter METHOD(email or text).'
    })
  }
  /*if (!req.user.phone) {
    return res.status(400).json({
      success: false,
      msg: 'ERROR: Missing user information(phone number).'
    })
  }*/
  const code = Math.random().toString().substr(2,4);
  console.log(code);
  const options = sendTextOption(req.user.phone, code)
  return res.status(200).json({
          success: true,
          msg: req.user
      })
}

function sendTextOption(phone, code){
  const message = `SFU Commute Verification Code: ${code}.`

  const options = { method: 'GET',
  url: 'https://rest.nexmo.com/sms/json',
  qs: 
    { api_key: config.nexmoApiKey,
      api_secret: config.nexmoApiSecret,
      to: phone,
      from: config.nexmoFromNumber,
      text: message 
    }
  }
  return options
}