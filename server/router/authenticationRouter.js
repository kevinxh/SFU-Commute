import express from 'express'
import { SignUp } from '../controller/authenticationController'

const authenticationRouter = express.Router()

authenticationRouter.get('/signup', SignUp)

export default authenticationRouter
