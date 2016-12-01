import request from 'request'
import moment from 'moment'
import Ride from '../model/ride'
import jwt from 'jsonwebtoken'
import path from 'path'
import config from '../config/secret'

export function createRide(req, res) {
  let { schedulerType,
        startLocationLat,
        startLocationLon,
        destinationLat,
        destinationLon,
        seats,
        date,} = req.body
  if (!schedulerType){
    return res.status(400).json({
      success: false,
      error: 'Are you a rider or driver?',
    })
  } else if (!startLocationLat || !startLocationLon || !destinationLat || !destinationLon){
    return res.status(400).json({
      success: false,
      error: 'Please enter correct locations.',
    })
  } else if (!seats) {
    return res.status(400).json({
      success: false,
      error: 'Please enter the number of seats available.',
    })
  } else if (!date) {
    return res.status(400).json({
      success: false,
      error: 'Please enter the date you want to schedule the ride at.',
    })
  }

  const ride = new Ride({
    scheduler: {
      schedulerType : schedulerType,
      user : req.user._id,
    },
    startLocation : {
      lat: startLocationLat,
      lon: startLocationLon,
    },
    destination : {
      lat: destinationLat,
      lon: destinationLon,
    },
    seats,
    date,
  })

  // Optional fields
  if(req.body.startLocationID){
    Object.assign(ride.startLocation, { id: req.body.startLocationID })
  }
  if(req.body.startLocationName){
    Object.assign(ride.startLocation, { name: req.body.startLocationName })
  }
  if(req.body.startLocationZone){
    Object.assign(ride.startLocation, { zone: req.body.startLocationZone })
  }
  if(req.body.startLocationPrice){
    Object.assign(ride.startLocation, { price: req.body.startLocationPrice })
  }
  if(req.body.destinationID){
    Object.assign(ride.destination, { id: req.body.destinationID })
  }
  if(req.body.destinationName){
    Object.assign(ride.destination, { name: req.body.destinationName })
  }
  if(req.body.destinationZone){
    Object.assign(ride.destination, { zone: req.body.destinationZone })
  }
  if(req.body.destinationPrice){
    Object.assign(ride.destination, { price: req.body.destinationPrice })
  }

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

export function getRide(req, res){
  if (!req.query.scheduleType){
    return res.status(400).json({
      success: false,
      error: 'Missing parameter: scheduleType.',
    })
  }
  var scheduleType
  if (req.query.scheduleType == 'Rider'){
    scheduleType = 'Rider'
  } else if (req.query.scheduleType == 'Driver'){
    scheduleType = 'Driver'
  } else if (req.query.scheduleType == 'Both'){
    scheduleType = 'Both'
  } else {
    return res.status(400).json({
      success: false,
      error: 'Invalid parameter: scheduleType.',
    })
  }

  var now = moment()
  if(scheduleType == 'Both'){
    Ride.find({date:{$gte:now}})
    	.populate('scheduler.user')
    	.exec((error, ride) => {
	      // if error finding an user
	      if (error) {
	        return res.status(403).json({
	          success: false,
	          error,
	        })
	      } else {
	        return res.status(201).json({ride})
	      }
	    })
  } else {
    Ride.find({date:{$gte:now}, 'scheduler.schedulerType': scheduleType})
    	.populate('scheduler.user')
    	.exec((error, ride)=>{
	      if (error) {
	        return res.status(403).json({
	          success: false,
	          error,
	        })
	      } else {
	        return res.status(201).json({ride})
	      }
	    })
  }
}

export function getRideByID(req, res){
  if (!(req.params.rideid)) {
    return res.status(400).json({
      success: false,
      error: 'Please enter specific ride ID.',
    })
  }
  if(req.params.rideid){
    Ride.findOne({"_id": req.params.rideid}, (error, ride) => {
      if (error) {
        return res.status(403).json({
          success: false,
          error,
        })
      }
      else{
        return res.status(201).json({ride})
      }
    })
  }
}

export function requestRideByID(req, res){
  if (!(req.params.rideid)) {
    return res.status(400).json({
      success: false,
      error: 'Please enter specific ride ID.',
    })
  }
  Ride.findOne({"_id": req.params.rideid}, (error, ride) => {
    if (error) {
      return res.status(403).json({
        success: false,
        error,
      })
    } else {
    	// this line is a bug, it returns false even if they are equal, to be fixed
      /*if(ride.pendingRequests.includes(req.user._id)){
        return res.status(400).json({
          success: false,
          error: "You already requested this ride.",
        })
      } else {*/
        ride.pendingRequests.push(req.user._id)
        ride.save(function(err) {
          if (err) {
            return res.status(403).json({
              success: false,
              error,
            })
          } else {
            return res.status(201).json({
              success: true,
              ride,
            })
          }
        })
      //}
    }
  })
}

export function deleteRideByID(req, res){
  if (!(req.params.rideid)) {
    return res.status(400).json({
      success: false,
      error: 'Please enter specific ride ID.',
    })
  }
  if(req.params.rideid){
    Ride.findOne({"_id": req.params.rideid}, (error, ride) => {
      if (error) {
        return res.status(403).json({
          success: false,
          error,
        })
      } else {
        // without toString, they are not equal even if values are the same, weird.
        if(ride.scheduler.user.toString() == req.user._id.toString()){
          ride.remove(function(err) {
            if (err) throw err;
            return res.status(201).json({
              success: true,
            })
          })
        } else {
          return res.status(400).json({
            success: false,
            error: "You are not the scheduler."
          })
        }
      }
    })
  }
}
