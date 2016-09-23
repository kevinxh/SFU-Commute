import User from '../model/user'

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
    return res.status(201).json({
      success: true,
      email,
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
        //const token = jwt.sign({ email: user.email }, config.JwtSecret, {
        //  expiresIn: 5184000, // 60 days in seconds
        //})
        return res.status(200).json({
          success: true,
          email,
      //    access_token: `JWT ${token}`,
        })
      }
      return 	res.status(401).json({
        success: false,
        msg: 'Authentication failed. Passwords did not match.',
      })
    })
  })
}
