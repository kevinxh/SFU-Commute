import express from 'express'
import passport from 'passport'
import authenticationRouter from './authenticationRouter'
import rideRouter from './rideRouter'

const router = express.Router()

router.get('/', function (req, res) {
  res.status(200).send('SFU-Commute server!')
})

router.use('/', authenticationRouter)
router.use('/ride', rideRouter)

export default router
