//
//  WeatherMenu.swift
//  InTheClear
//
//  Created by Josh Sauder on 10/15/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class weatherMenu: UIViewController, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    @IBOutlet weak var directionsImage: UIImageView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!


    func createView(directions: [String], city: [String], weather: [String]) {
        
        let weatherCell = weather.first
        
        if weatherCell == "Rain" {
            weatherImage.image = UIImage.fontAwesomeIcon(
                name: .tint,
                style: .solid,
                textColor: .blue,
                size: CGSize(width: 50, height: 50)
                )
        } else if weatherCell == "Thunderstorm" {
            weatherImage.image = UIImage.fontAwesomeIcon(
                name: .bolt,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )

        } else if weatherCell == "Snow" {
            weatherImage.image = UIImage.fontAwesomeIcon(
                name: .snowflake,
                style: .solid,
                textColor: .blue,
                size: CGSize(width: 50, height: 50)
            )
            
        } else {
            weatherImage.image = UIImage.fontAwesomeIcon(
                name: .sun,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        }
        
        let directionsCell = directions.first
        if directionsCell == "turn-sharp-left" || directionsCell == "turn-slight-left" || directionsCell == "turn-left" || directionsCell == "ramp-left" || directionsCell == "roundabout-left" || directionsCell == "ramp-left" || directionsCell == "keep-left" {
            directionsImage.image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleLeft,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        } else if directionsCell == "turn-sharp-right" || directionsCell == "turn-slight-right" || directionsCell == "turn-right" || directionsCell == "ramp-right" || directionsCell == "roundabout-right" || directionsCell == "ramp-right" || directionsCell == "keep-right" {
            directionsImage.image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleRight,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        }
        else if directionsCell == "uturn-left"{
            directionsImage.image = UIImage.fontAwesomeIcon(
                name: .undo,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
                
        } else if directionsCell == "uturn-right"{
            directionsImage.image = UIImage.fontAwesomeIcon(
                name: .redo,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
            }
         else {
            directionsImage.image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleUp,
                style: .solid,
                textColor: .yellow,
                size: CGSize(width: 50, height: 50)
            )
        }
        
    }
}
