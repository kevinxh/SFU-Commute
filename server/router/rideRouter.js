import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import * as controller from '../controller/rideController'

const rideRouter = express.Router()

rideRouter
  .post('/', JWTAuthentication, controller.createRide)
  .get('/', controller.getRide)
  .get('/:rideid', controller.getRideByID)
  .put('/request/:rideid', JWTAuthentication, controller.requestRideByID)
  .delete('/:rideid', JWTAuthentication, controller.deleteRideByID)

export default rideRouter
