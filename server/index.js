import express from './config/express'
import router from './router'
import mongoose from './config/mongoose'

mongoose()
const app = express()
app.use(router)

export default app
