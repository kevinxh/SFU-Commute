import express from 'express'
import authenticationRouter from './authenticationRouter'

const router = express.Router()

router.get('/', function (req, res) {
  res.status(200).send('Initialize SFU-Commute backend server!')
})

router.use('/auth', authenticationRouter);

export default router
