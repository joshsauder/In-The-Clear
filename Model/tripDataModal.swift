//
//  tripData.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/25/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation

class tripDataModal {

    var times: [Date] = []
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
    }
    
    func removeAll(){
        //removes all from trip data arrays
        times.removeAll()
        conditions.removeAll()
        cities.removeAll()
        highTemps.removeAll()
        conditionDescription.removeAll()
    }
    
    func reverse(){
        //order from start location to finish
        cities.reverse()
        conditions.reverse()
        highTemps.reverse()
        conditionDescription.reverse()
    }
}
