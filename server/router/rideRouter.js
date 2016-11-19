import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import * as controller from '../controller/rideController'

const rideRouter = express.Router()

rideRouter
  .post('/ride', controller.OfferRide)
  .get('/ride', controller.allRide)
  .get('/ride/:rideid', controller.allRideId)
  .put('/ride/:rideid/:userid', controller.rideUpdate)

export default rideRouter
