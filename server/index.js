import mongoose from './config/mongoose' // import mongoose model before passport!
import express from './config/express'
import router from './router'

mongoose()
const app = express()
app.use(router)

export default app
