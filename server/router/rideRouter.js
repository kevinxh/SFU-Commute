import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import * as controller from '../controller/rideController'

const rideRouter = express.Router()

rideRouter
  .post('/', controller.OfferRide)
  .get('/', controller.allRide)
  .get('/:rideid', controller.allRideId)
  .put('/:rideid/:userid', controller.rideUpdate)
  .delete('/:rideid', controller.rideDelete)

export default rideRouter
