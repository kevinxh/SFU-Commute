import User from '../model/user'

export function SignUp(req, res) {
  if (!req.body.email || !req.body.password) {
    console.log(req)
    return res.status(400).json({
      success: false,
      msg: 'Please enter your email and password.',
    })
  }
  const user = new User({
    email: req.body.email,
    password: req.body.password,
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
      email: user.email,
    })
  })
}
