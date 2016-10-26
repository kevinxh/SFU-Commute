import mongoose from './config/mongoose' // import mongoose model before passport!
import express from './config/express'

// Initialize Database Configurations
mongoose()

// Initialize Server Configurations
const app = express()

const port = 3000
app.listen(process.env.PORT || port, function () {
   console.log(`SFU-Commute server! port: ${port}`)
})

export default app
