import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import * as controller from '../controller/rideController'

const rideRouter = express.Router()

rideRouter
  .post('/offer/ride', controller.OfferRide)
  .get('/all/ride', controller.allRide)

export default rideRouter
