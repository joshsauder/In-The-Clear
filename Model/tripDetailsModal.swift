//
//  tripDetailsModal.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/26/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation

class tripDetailsModal {
    var cityStops: [String] = []
    var startTimes: [Date] = []
    
    
    init() {
        self.cityStops = []
        self.startTimes = []
    }
    
    func reorderItems(startIndex: Int, destIndex: Int){
        let city = cityStops.remove(at: startIndex)
        let time = startTimes.remove(at: startIndex)
        
        cityStops.insert(city, at: destIndex)
        startTimes.insert(time, at: destIndex)
    }
    
    func removeItems(index: Int){
        cityStops.remove(at: index)
        startTimes.remove(at: index)
    }
}
