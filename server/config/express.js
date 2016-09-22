import express from 'express'
import bodyParser from 'body-parser'
import morgan from 'morgan'

export default function(){
  let app = express()
  app.use(bodyParser.json())
  app.use(bodyParser.urlencoded({ extended: false }))
  app.use(morgan('dev'))
  const port = 8080
  app.listen(port, function () {
    console.log('Initialize SFU-Commute backend server!')
  })
  return app
}
