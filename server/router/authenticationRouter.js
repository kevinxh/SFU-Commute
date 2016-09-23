import express from 'express'
import { SignUp, SignIn } from '../controller/authenticationController'

const authenticationRouter = express.Router()

authenticationRouter
  .post('/signup', SignUp)
  .post('/signin', SignIn)

export default authenticationRouter
