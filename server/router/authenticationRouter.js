import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import * as controller from '../controller/authenticationController'

const authenticationRouter = express.Router()

authenticationRouter
  .post('/signup', controller.SignUp)
  .post('/signin', controller.SignIn)
  .post('/verify/text', JWTAuthentication, controller.VerifyText)
  .get('/verify/text', JWTAuthentication, controller.VerifyTextCheck)
  .post('/forgot', controller.Forgot)
  .get('/reset', controller.ResetPage)
  .post('/reset', controller.Reset)

export default authenticationRouter
