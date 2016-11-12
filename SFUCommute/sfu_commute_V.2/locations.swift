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
    location(id: 1, lat: 49.2756237, lon: -123.0032437, name: "Parker - Willingdon", zone: .C, price: 2.0),
    location(id: 2, lat: 49.2664946, lon: -123.0031278, name: "Brentwood Skytrain Station", zone: .C, price: 2.0),
    location(id: 3, lat: 49.275542, lon: -122.992168, name: "Parker - Delta", zone: .C, price: 2.0),
    location(id: 4, lat: 49.2803453, lon: -122.9809395, name: "Hastings - Holdom", zone: .A, price: 2.0),
    location(id: 5, lat: 49.2755029, lon: -122.980982, name: "Curtis - Holdom", zone: .C, price: 2.0),
    location(id: 6, lat: 49.2647455, lon: -122.9843549, name: "Holdom Skytrain Station", zone: .C, price: 2.0),
    location(id: 7, lat: 49.2802981, lon: -122.9700205, name: "Hastings - Kensington", zone: .B, price: 1.0),
    location(id: 8, lat: 49.2803565, lon: -122.9646664, name: "Hastings - Sperling", zone: .B, price: 1.0),
    location(id: 9, lat: 49.2752175, lon: -122.9700789, name: "Curtis - Kensington", zone: .D, price: 1.0)

]
