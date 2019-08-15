//
//  tripDetailsModal.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/26/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import CoreLocation


class tripDetailsModal {
    var cityStops: [String] = []
    var cityLocations: [CLLocation] = []
    var startTimes: [Date] = []
    var endTime: Date = Date()
    
    
    init() {
        self.cityStops = []
        self.startTimes = []
        self.cityLocations = []
        self.endTime = Date()
    }
    
    /**
     Reorders items in arrays
     
     - parameters:
        - startIndex: The intial index
        - destIndex: The desination index
    */
    func reorderItems(startIndex: Int, destIndex: Int){
        let city = cityStops.remove(at: startIndex)
        let time = startTimes.remove(at: startIndex)
        let loc = cityLocations.remove(at: startIndex)
        
        cityStops.insert(city, at: destIndex)
        startTimes.insert(time, at: destIndex)
        cityLocations.insert(loc, at: destIndex)
    }
    
    /**
     Removes items in arrays
    
     - parameters:
        - index: Index of item to remove
    */
    func removeItems(index: Int){
        cityStops.remove(at: index)
        startTimes.remove(at: index)
        cityLocations.remove(at: index)
    }
    
    /**
     Adds city to trip details modal
     
     - parameters:
     - city: The city
     - loc: cities geocoordinates
     - index: index of city in table
     */
    func addCity(city: String, loc: CLLocation, index: Int) {
        cityStops.insert(city, at: index)
        startTimes.insert(Date(), at: index)
        cityLocations.insert(loc, at: index)
    }
}
