import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import { SignUp, SignIn, Verify, VerifyCheck} from '../controller/authenticationController'

const authenticationRouter = express.Router()

authenticationRouter
  .post('/signup', SignUp)
  .post('/signin', SignIn)
  .post('/verify', JWTAuthentication, Verify)
  .get('/verify', JWTAuthentication, VerifyCheck)

export default authenticationRouter
