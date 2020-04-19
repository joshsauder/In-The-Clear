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
    @objc dynamic var locations: [Locations] = []
}

class Locations: Object {
    @objc dynamic var city = ""
    @objc dynamic var condition = ""
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""
}
