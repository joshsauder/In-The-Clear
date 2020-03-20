//
//  tripData.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/25/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import CoreLocation

class tripDataModal {

    var times: [Date] = []
    var stops: [String] = []
    var stopLocations: [CLLocation] = []
    var conditions: [String] = []
    var cities: [String] = []
    var highTemps: [Float] = []
    var conditionDescription: [String] = []
    
    init() {
        self.times = []
        self.conditions = []
        self.cities = []
        self.highTemps = []
        self.conditionDescription = []
        self.stops = []
        self.stopLocations = []
    }
    
    /**
     Removes all values from trip value arrays
    */
    internal func removeAll(){
        conditions.removeAll()
        cities.removeAll()
        highTemps.removeAll()
        conditionDescription.removeAll()
    }
    
    /**
     Reverses all arrays so the order is start to finish
    */
    internal func reverse(){
        cities.reverse()
        conditions.reverse()
        highTemps.reverse()
        conditionDescription.reverse()
    }
}
