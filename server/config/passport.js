import passport from 'passport'
import { passportJWT } from './passport-jwt.js'

export default function () {
  passportJWT(passport)
}
