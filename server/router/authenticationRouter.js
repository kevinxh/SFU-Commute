import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import { SignUp, SignIn, Verify } from '../controller/authenticationController'

const authenticationRouter = express.Router()

authenticationRouter
  .post('/signup', SignUp)
  .post('/signin', SignIn)
  .get('/verify', JWTAuthentication, Verify)

export default authenticationRouter
