//
//  locations.swift
//  sfu_commute_V.2
//
//  Created by Tianxiong He on 2016-11-10.
//  Copyright © 2016 Lightspeed-Tech. All rights reserved.
//

import Foundation
import CoreLocation

// make the set Hashable
extension location: Hashable, Equatable {
    var hashValue: Int { return id.hashValue ^ name.hashValue }
}

func ==(lhs: location, rhs: location) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}

enum zones : String{
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
}

struct location {
    var id : Int
    var lat : CLLocationDegrees
    var lon : CLLocationDegrees
    var name : String
    var zone : zones
    var price : Decimal
}

let preDeterminedLocations : [location] = [
    location(id: 0, lat: 49.281019, lon: -123.0031033, name: "Hastings - Willingdon", zone: .A, price: 2.0),
    location(id: 1, lat: 49.2756237, lon: -123.0032437, name: "Parker - Willingdon", zone: .A, price: 2.0),
    location(id: 2, lat: 49.2664946, lon: -123.0031278, name: "Brentwood Skytrain Station", zone: .A, price: 2.0),
    location(id: 3, lat: 49.275542, lon: -122.992168, name: "Parker - Delta", zone: .A, price: 2.0),
    location(id: 4, lat: 49.2803453, lon: -122.9809395, name: "Hastings - Holdom", zone: .A, price: 2.0),
    location(id: 5, lat: 49.2755029, lon: -122.980982, name: "Curtis - Holdom", zone: .A, price: 2.0),
    location(id: 6, lat: 49.264821, lon: -122.981469, name: "Holdom Skytrain Station", zone: .A, price: 2.0),
    
    location(id: 7, lat: 49.2802981, lon: -122.9700205, name: "Hastings - Kensington", zone: .B, price: 1.0),
    location(id: 8, lat: 49.2752175, lon: -122.9700789, name: "Curtis - Kensington", zone: .B, price: 1.0),
    location(id: 9, lat: 49.267986, lon: -122.970104, name: "Halifax - Kensington", zone: .B, price: 1.0),
    location(id: 10, lat: 49.2626492, lon: -122.9701872, name: "Broadway - Kensington", zone: .B, price: 1.0),
    location(id: 11, lat: 49.2803565, lon: -122.9646664, name: "Hastings - Sperling", zone: .B, price: 1.0),
    location(id: 12, lat: 49.2752134, lon: -122.9646611, name: "Curtis - Sperling", zone: .B, price: 1.0),
    location(id: 13, lat: 49.2679789, lon: -122.964592, name: "Halifax - Sperling", zone: .B, price: 1.0),
    location(id: 14, lat: 49.261584, lon: -122.964627, name: "Broadway - Sperling", zone: .B, price: 1.0),
    location(id: 15, lat: 49.259286, lon: -122.964581, name: "Sperling Skytrain Station", zone: .B, price: 1.0),
    location(id: 16, lat: 49.2803255, lon: -122.9533672, name: "Hastings - Duthie", zone: .B, price: 1.0),
    location(id: 17, lat: 49.2752049, lon: -122.9534524, name: "Curtis - Duthie", zone: .B, price: 1.0),
    location(id: 18, lat: 49.27158, lon: -122.953496, name: "Kitchener - Duthie", zone: .B, price: 1.0),
    location(id: 19, lat: 49.2679797, lon: -122.9533713, name: "Halifax - Duthie", zone: .B, price: 1.0),
    location(id: 20, lat: 49.2610712, lon: -122.9534171, name: "Broadway - Duthie", zone: .B, price: 1.0),
    location(id: 21, lat: 49.258827, lon: -122.956034, name: "Lougheed - Bainbridge", zone: .B, price: 1.0)
]
