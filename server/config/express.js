import express from 'express'
import bodyParser from 'body-parser'
import morgan from 'morgan'
import passport from 'passport'
import passportStrategies from './passport'
import swagger from './swag'

export default function(){
  let app = express()
  app.use(bodyParser.json())
  app.use(bodyParser.urlencoded({ extended: false }))
  if(process.env.NODE_ENV === 'development'){
    app.use(morgan('dev'))
  }
  swagger(app)
  app.use(passport.initialize())
  passportStrategies()
  const port = 3000
  app.listen(process.env.PORT || port, function () {
    console.log('SFU-Commute server!')
  })
  return app
}
