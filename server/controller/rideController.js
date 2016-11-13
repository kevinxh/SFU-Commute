import request from 'request'
import moment from 'moment'
import Ride from '../model/ride'
import jwt from 'jsonwebtoken'
import path from 'path'
import config from '../config/secret'

export function OfferRide(req, res) {
  let { startlocation, destination, seats } = req.body
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
  }
  const ride = new Ride({
    startlocation,
    destination,
    seats
  })
  console.log("")
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