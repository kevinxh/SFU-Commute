import request from 'request'
import moment from 'moment'
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

  switch (req.query.method) {
  	case 'text':
  		if (!req.query.phone || req.query.phone.length != 11){
  			return res.status(400).json({
        			success: false,
        			msg: 'ERROR: Missing parameter:  11-digit phone number.',
      		})
  		}
  		var code = genCode(4)
  		const options = sendTextOption(req.query.phone, code)
  		request(options, function (error, response, body) {
  			if (error) {
          return res.status(500).json({
                      success: false,
                      error
                  })
        }
        const parsedBody = JSON.parse(body)
        const status =  parsedBody.messages[0].status
  			if( status === '0') {
          const expiresInFive = moment().add(5, 'm');
          User.findOneAndUpdate({email: req.user.email},
                {'phone.number': req.query.phone,
                 'phone.verification.code': code,
                 'phone.verification.expire': expiresInFive},
                {new: true,
                 runValidators: true},
                function(error, user){
                  if(error){
                    return res.status(400).json({
                      success: false,
                      error
                    })
                  }
                  return res.status(200).json({
                      success: true,
                      user
                  })
                })
        } else {
          return res.status(500).json({
                      success: false,
                      msg: `Message delievery failed, SMS API response status code: ${status}. Please check https://docs.nexmo.com/messaging/sms-api/api-reference .`,
                  })
        }
		  })
		  
  		break
  	case 'email':
  		console.log('method: email')
  		break
  	default:
  		return res.status(400).json({
      		success: false,
      		msg: 'ERROR: Missing parameter METHOD(email or text).'
    	})
  }
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

function genCode(digits){
  let code = Math.floor(Math.pow(10, digits+1) + Math.random() * 9*Math.pow(10, digits+1)).toString().substring(1,digits+1)
  return code
}