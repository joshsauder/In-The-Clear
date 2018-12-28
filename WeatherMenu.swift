//
//  WeatherMenu.swift
//  InTheClear
//
//  Created by Josh Sauder on 10/15/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class weatherMenu: UITableViewController {
    
    var weatherDataArray: [weatherData.Entry] = []
    
    var backgroundColor = UIColor.init(red: 132, green: 29, blue: 132, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNav()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let entry = weatherDataArray[indexPath.row]
        cell.directionsImage.image = directionsImage(directions: entry.directions)
        cell.weatherImage.image = weatherImage(weather: entry.weather)
        cell.cityLabel.text = entry.city
        cell.directionsLabel.text = entry.directions
        cell.backgroundColor = cellColor(weather: entry.weather)
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 4
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    func setUpNav() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backButtonPressed))
        backButton.title = "Back"
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func cellColor(weather: String) -> UIColor {
        
        var color = UIColor()
        
        if weather == "Rain" {
            color = UIColor.green
            
        } else if weather == "Thunderstorm" {
            color = UIColor.red
            
        } else if weather == "Snow" {
            color = UIColor.blue
            
        } else {
            color = UIColor.yellow
        }
        
        return color
    }
    

    func directionsImage(directions: String) -> UIImage {
        var image = UIImage()
        if directions == "turn-sharp-left" || directions == "turn-slight-left" || directions == "turn-left" || directions == "ramp-left" || directions == "roundabout-left" || directions == "ramp-left" || directions == "keep-left" {
            image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleLeft,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
        } else if directions == "turn-sharp-right" || directions == "turn-slight-right" || directions == "turn-right" || directions == "ramp-right" || directions == "roundabout-right" || directions == "ramp-right" || directions == "keep-right" {
            image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleRight,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
        }
        else if directions == "uturn-left"{
            image = UIImage.fontAwesomeIcon(
                name: .undo,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
            
        } else if directions == "uturn-right"{
            image = UIImage.fontAwesomeIcon(
                name: .redo,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
        }
        else {
            image = UIImage.fontAwesomeIcon(
                name: .arrowAltCircleUp,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
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
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
        } else if weather == "Thunderstorm" {
            image = UIImage.fontAwesomeIcon(
                name: .bolt,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
            
        } else if weather == "Snow" {
            image = UIImage.fontAwesomeIcon(
                name: .snowflake,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
            
        } else {
            image = UIImage.fontAwesomeIcon(
                name: .sun,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 20, height: 15)
            )
        }
        return image
    }

}
