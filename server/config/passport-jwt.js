import config from './secret'
import Passport from 'passport'
import User from '../model/user'
const JwtStrategy = require('passport-jwt').Strategy
const ExtractJwt = require('passport-jwt').ExtractJwt
//const User = require('mongoose').model('User')

export const passportJWT = function (passport) {
  passport.use(new JwtStrategy({
    jwtFromRequest: ExtractJwt.fromAuthHeader(),
    secretOrKey: config.JwtSecret,
  }, (jwtPayload, done) => {
    User.findOne({ email: jwtPayload.email }, (err, user) => {
      if (err) return done(err, false)
      if (user) {
        return done(null, user)
      }
      return done(null, false)
    })
  }))
}

export const JWTAuthentication = (req, res, next) => {
  Passport.authenticate('jwt', {session:false}, function (err, user, info){
    if (err) {
      return res.status(401).json({
          success: false,
          msg:err
      })
    } else if (!user) {
      return res.status(400).json({
          success: false,
          error:'Error: The request is missing correct access token.'
      })
    } else {
      req.user = user
      next()
    }
  })(req, res, next)
}
