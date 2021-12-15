//
//  TripData.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/18/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import RealmSwift

class TripData: Object {
    @objc dynamic var tripId = ""
    @objc dynamic var duration = ""
    @objc dynamic var distance = ""
    @objc dynamic var createdAt: Date = Date()
    var locations = RealmSwift.List<Locations>()
}

class Locations: Object {
    @objc dynamic var city = ""
    @objc dynamic var condition = ""
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
}

struct FirebaseTrips: Codable {
    let trips: [FirebaseTripData]
    
    enum CodingKeys: String, CodingKey {
        case trips
    }
}

struct FirebaseTripData: Codable {
    let duration: Int
    let distance: Int
    let locations: [LocationData]
    let dateAdded: String
    
    enum CodingKeys: String, CodingKey {
        case duration
        case distance
        case locations
        case dateAdded
    }
}

struct LocationData: Codable {
    let city: String
    let condition: String
    let longitude: Double
    let latitude: Double
    let temperature: Int
    
    enum CodingKeys: String, CodingKey {
        case city
        case condition
        case longitude
        case latitude
        case temperature
    }
}
