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

let preDeterminedLocations : Set<location> = [
    location(id: 0, lat: 49.281019, lon: -123.0031033, name: "Hastings - Willingdon", zone: .A, price: 2.0),
    location(id: 1, lat: 49.2756237, lon: -123.0032437, name: "Parker - Willingdon", zone: .A, price: 2.0)
]
