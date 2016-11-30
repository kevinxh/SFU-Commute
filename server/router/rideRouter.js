import express from 'express'
import { JWTAuthentication } from '../config/passport-jwt.js'
import * as controller from '../controller/rideController'

const rideRouter = express.Router()

rideRouter
  .post('/', controller.createRide)
  .get('/', controller.getRide)
  .get('/:rideid', controller.getRideByID)
  .put('/:rideid/:userid', controller.updateRideByID)
  .delete('/:rideid', controller.deleteRideByID)

export default rideRouter
