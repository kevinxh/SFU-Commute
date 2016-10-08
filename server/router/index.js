import express from 'express'
import passport from 'passport'
import authenticationRouter from './authenticationRouter'

const router = express.Router()

router.get('/', function (req, res) {
  res.status(200).send('SFU-Commute server!')
})

router.use('/auth', authenticationRouter)

export default router
