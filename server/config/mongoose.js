import config from './secret'
import mongoose from 'mongoose'

// Registering models
require('../model/user')

export default function () {
  mongoose.Promise = global.Promise;
  mongoose.connect(config.db_connection_url)

  if(process.env.NODE_ENV === 'development'){
    mongoose.connection.on('connected',function(){
      console.log('MongoDB connected')
    })
    mongoose.connection.on('disconnected',function(){
      console.log('MongoDB disconnected')
    })
    mongoose.connection.on('err',function(err){
      console.log(`MongoDB connection error:${err}`)
    })
  }
}
