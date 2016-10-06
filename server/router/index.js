import express from 'express'
import authenticationRouter from './authenticationRouter'
import { JWTAuthentication } from '../config/passport-jwt.js'

const router = express.Router()

router.get('/', function (req, res) {
  res.status(200).send('Initialize SFU-Commute backend server!')
})

router.use('/auth', authenticationRouter);
router.get('/test', JWTAuthentication, function(req, res){
  return res.status(200).json({
  success: true,
  user: req.user
})});

export default router
