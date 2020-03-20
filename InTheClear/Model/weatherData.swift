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
        var city: String
        var highTemp: Float
        var condition: String
        
        init(weather: String, city: String, highTemp: Float, condition: String){
            self.weather = weather
            self.city = city
            self.highTemp = highTemp
            self.condition = condition
        }
    }
        
    let weatherDataArray: [Entry] = []
    
}
