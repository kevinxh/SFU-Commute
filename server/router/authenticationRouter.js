import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import * as controller from '../controller/authenticationController'

const authenticationRouter = express.Router()

authenticationRouter
  .post('/signup', controller.SignUp)
  .post('/signin', controller.SignIn)
  .post('/verify', JWTAuthentication, controller.Verify)
  .get('/verify', JWTAuthentication, controller.VerifyCheck)
  .post('/forgot', controller.Forgot)
  .get('/reset', controller.Reset)

export default authenticationRouter
