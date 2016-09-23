import express from 'express'
import { SignUp } from '../controller/authenticationController'

const authenticationRouter = express.Router()

authenticationRouter.post('/signup', SignUp)

export default authenticationRouter
