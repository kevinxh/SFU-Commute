import mongoose, { Schema } from 'mongoose'
import UserSchema from './user'
import bcrypt from 'bcrypt'

const LocationSchema = new Schema({
  id: Number,
  lat: {
    type: String,
    required: 'Latitude is required.',
  },
  lon: {
    type: String,
    required: 'Longtitude is required.',
  },
  name: String,
  zone: {
    type: String,
    enum: ['A','B','C','D','E','F','G'],
  },
  price: Number,
})

const RideSchema = new Schema({
  scheduler: {
    user: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: 'Scheduler information is required.',
      index: true,
    },
    schedulerType: {
      type: String,
      enum: ['Rider', 'Driver'],
      required: 'Scheduler type is required.',
    },
  },
  startLocation: LocationSchema,
  destination: LocationSchema,
  seats: {
    type: Number,
    required: 'Available seats is required.',
  },
  date: {
    type: Date,
    required: 'The date of the scheduled ride is required.',
  },
  pendingRequests: [{
    type: Schema.Types.ObjectId,
    ref: 'User',
  }],
  approvedRequests:[{
    type: Schema.Types.ObjectId,
    ref: 'User',
  }],
  created: {
    type: Date,
    default: Date.now,
  },
}, { collection: 'Ride' })

/*RideSchema.pre('save', function (next) {
  const ride = this
  if (ride.isModified('startlocation') || ride.isNew) {
    ride.startlocation = ride.startlocation.toLowerCase()
  }
  if (ride.isModified('destination') || ride.isNew) {
    ride.destination = ride.destination.toLowerCase()
  }
  return next()
})*/

export default mongoose.model('Ride', RideSchema)
