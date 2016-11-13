import mongoose, { Schema } from 'mongoose'
import bcrypt from 'bcrypt'

const UserSchema = new Schema({
  startlocation: {
    type: String,
    lowercase: true,
    unique: true,
    index: true,
    required: 'start location is required',
  },
  destination: {
    type: String,
    trim: true,
    required: 'destination is required',
  },
  seats: {
    type: String,
    trim: true,
    required: 'number of seats available are required',
  },
  created: {
    type: Date,
    default: Date.now,
  },
}, { collection: 'ride' })


UserSchema.pre('save', function (next) {
  const ride = this
  if (ride.isModified('startlocation') || ride.isNew) {
    ride.startlocation = ride.startlocation.toLowerCase()
  }
  if (ride.isModified('destination') || ride.isNew) {
    ride.destination = ride.destination.toLowerCase()
  }
})

export default mongoose.model('Ride', UserSchema)
