import request from 'request'
import moment from 'moment'
import Ride from '../model/ride'
import jwt from 'jsonwebtoken'
import path from 'path'
import config from '../config/secret'

export function OfferRide(req, res) {
  let { startlocation, destination, seats, ride_time, ride_date } = req.body
  if (!startlocation) {
    return res.status(400).json({
      success: false,
      error: 'Please enter your start location.',
    })
  } else if (!destination){
    return res.status(400).json({
      success: false,
      error: 'Please enter your destination.',
    })
  } else if (!seats) {
    return res.status(400).json({
      success: false,
      error: 'Please enter the number of seats available.',
    })
  } else if (!ride_time) {
    return res.status(400).json({
      success: false,
      error: 'Please enter the time.',
    })
  } else if (!ride_date) {
    return res.status(400).json({
      success: false,
      error: 'Please enter the date you want to schedule the ride at.',
    })
  }
  const ride = new Ride({
    startlocation,
    destination,
    seats,
    ride_time,
    ride_date
  })
  ride.save((error) => {
    if (error) {
      return  res.status(403).json({
        success: false,
        error,
      })
    }
    return res.status(201).json({
      success: true,
      ride
    })
  })
}


export function allRide(req, res){
    Ride.find({}, (error, ride) => {
      // if error finding an user
      if (error) {
        return res.status(403).json({
          success: false,
          error,
        })
      } 
      else
        return res.status(201).json({ride})
      console.log(ride)
      // if no such user
    })
  }