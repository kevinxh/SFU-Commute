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
  ride_time: {
    type: String,
    trim: true,
    match: [/^(((([0-1][0-9])|(2[0-3])):?[0-5][0-9])|(24:?00))/, 'Please fill a valid time '],
    required: 'the ride start time',
  },
  ride_date: {
    type: String,
    trim: true,
    match: [/^\d\d\d\d-(0[1-9]|1[0-2])-(0[1-9]|[1-2]\d|3[0-1])$/, 'Please fill a valid date'],
    required: 'the date of the scheduled ride',
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
    return next()
  }
  if (ride.isModified('destination') || ride.isNew) {
    ride.destination = ride.destination.toLowerCase()
    return next()
  }
})

export default mongoose.model('Ride', UserSchema)
