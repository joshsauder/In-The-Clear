//
//  WeatherMenu.swift
//  InTheClear
//
//  Created by Josh Sauder on 10/15/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class weatherMenu: UITableView {
    
    var weatherDataArray: [weatherData.Entry] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        let entry = weatherDataArray[indexPath.row]
        cell.directionsImage.image = directionsImage(directions: entry.directions)
        cell.weatherImage.image = weatherImage(weather: entry.weather)
        cell.cityLabel.text = entry.city
        cell.directionsLabel.text = entry.directions
        
        return cell
    }
    
    

    func directionsImage(directions: String) -> UIImage {
        var image = UIImage()
        if directions == "turn-sharp-left" || directions == "turn-slight-left" || directions == "turn-left" || directions == "ramp-left" || directions == "roundabout-left" || directions == "ramp-left" || directions == "keep-left" {
            image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleLeft,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        } else if directions == "turn-sharp-right" || directions == "turn-slight-right" || directions == "turn-right" || directions == "ramp-right" || directions == "roundabout-right" || directions == "ramp-right" || directions == "keep-right" {
            image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleRight,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        }
        else if directions == "uturn-left"{
            image = UIImage.fontAwesomeIcon(
                name: .undo,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
            
        } else if directions == "uturn-right"{
            image = UIImage.fontAwesomeIcon(
                name: .redo,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        }
        else {
            image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleUp,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        }
        return image
    }
    
    func weatherImage(weather: String) -> UIImage {
        var image = UIImage()
        if weather == "Rain" {
            image = UIImage.fontAwesomeIcon(
                name: .tint,
                style: .solid,
                textColor: .blue,
                size: CGSize(width: 50, height: 50)
            )
        } else if weather == "Thunderstorm" {
            image = UIImage.fontAwesomeIcon(
                name: .bolt,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
            
        } else if weather == "Snow" {
            image = UIImage.fontAwesomeIcon(
                name: .snowflake,
                style: .solid,
                textColor: .blue,
                size: CGSize(width: 50, height: 50)
            )
            
        } else {
            image = UIImage.fontAwesomeIcon(
                name: .sun,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        }
        return image
    }
    
    func loadData(weather: [String], directionsData: [String], cityData:[String]){
        
        let i = 0
        while i < weather.count {
            var entry = weatherData.Entry(weather: "", directions: "", city: "")
            entry.city = cityData[i]
            entry.directions = directionsData[i]
            entry.weather = weather[i]
            weatherDataArray.append(entry)
        }
    }

}
