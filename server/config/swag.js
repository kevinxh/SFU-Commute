import express from 'express'
import path from 'path'
import swagger from 'swagger-node-express'

export default function (app) {
  let swaggerInstance = express.Router()

  swagger.setAppHandler(swaggerInstance)
  swaggerInstance.use(express.static(path.resolve(__dirname + '/../swagger')))
  swaggerInstance.get('/', function (req, res) {
    res.sendFile(path.resolve(__dirname + '/../swagger/index.html'))
  })
  swagger.setApiInfo({
    title: "SFU Commute API",
    description: "A detailed representation of SFU Commute RESTful API. ",
    termsOfServiceUrl: "",
    contact: "k.he933@gmail.com",
    license: "",
    licenseUrl: ""
  })
  app.use('/doc', swaggerInstance)
  swagger.configureSwaggerPaths('', 'api-docs', '')
  const port = 3000
  swagger.configure(`http://54.69.64.180/`, '1.0.0')
}
