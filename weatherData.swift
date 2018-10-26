//
//  weatherData.swift
//  InTheClear
//
//  Created by Josh Sauder on 10/25/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation

class weatherData {
    
    class Entry {
        var weather: String
        var directions: String
        var city: String
        init(weather: String, directions: String, city: String){
            self.weather = weather
            self.directions = directions
            self.city = city
        }
    }
        
    let weatherDataArray: [Entry] = []
    
}
