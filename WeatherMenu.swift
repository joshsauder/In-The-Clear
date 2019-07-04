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
    
    //will be equal to the weatherDataVals array in ViewController
    var weatherDataArray: [weatherData.Entry] = []
    
    var backgroundColor = UIColor.init(red: 132, green: 29, blue: 132, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up weatherTable
        setUpNav()
        tableView.separatorStyle = .none
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create single weather cell at specified row
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let entry = weatherDataArray[indexPath.row]
        //set image, cityLabel, tempLabel, and conditionLabel equal to corresponding values
        cell.weatherImage?.image = weatherImage(weather: entry.weather)
        cell.cityLabel?.text = entry.city
        cell.tempLabel?.text = "\(Int(entry.highTemp.rounded()))℉"
        cell.conditionLabel?.text = entry.condition.capitalized
        
        //needs to be clear so gradient shows
        cell.backgroundColor = UIColor.clear
        //Create gradient color
        let colorArray = cellColor(weather: entry.weather)
        cell.colorCell(firstColor: colorArray[0], secondColor: colorArray[1])
        //set cell radius and width.
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 6
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    /**
     Sets up navigation bar at top
    */
    func setUpNav() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.backButtonPressed))
        backButton.title = "Back"
        navigationItem.leftBarButtonItem = backButton
    }
    
    /**
     Controls when back button pressed in navigation bar
    */
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

    /**
     Function that determines cells colors depending on condition
     
     - parameter weather: The weather condition
     - returns: An array containing two UIColors
    */
    func cellColor(weather: String) -> [UIColor] {
        //two colors needed for gradient
        var colorOne = UIColor()
        var colorTwo = UIColor()
        
        if weather == "rain" {
            colorOne = UIColor(red:0.40, green:0.73, blue:0.42, alpha:1.0)
            colorTwo = UIColor(red:0.26, green:0.63, blue:0.28, alpha:1.0)
            
        } else if weather == "Thunderstorm" {
            colorOne = UIColor(red:0.94, green:0.33, blue:0.31, alpha:1.0)
            colorTwo = UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0)
            
        } else if weather == "snow" || weather == "sleet" {
            colorOne = UIColor(red:0.26, green:0.65, blue:0.96, alpha:1.0)
            colorTwo = UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)
            
        } else if weather == "clouds" || weather == "partly-cloudy-day" || weather == "partly-cloudy-night" {
            colorOne = UIColor(red:0.56, green:0.64, blue:0.68, alpha:1.0)
            colorTwo = UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0)
            
        }
        else {
            colorOne = UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0)
            colorTwo = UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0)
        }

        return [colorOne, colorTwo]
    }
    
    /**
     Function that determines weather image depending on condition
     
     - parameter weather: The weather condition
     - returns: A UIImage that relates to the weather condition
    */
    func weatherImage(weather: String) -> UIImage {
        var image = UIImage()
        if weather == "rain" {
            image = UIImage.fontAwesomeIcon(
                name: .cloudShowersHeavy,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 14, height: 9)
            )
        } else if weather == "Thunderstorm" {
            image = UIImage.fontAwesomeIcon(
                name: .bolt,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 14, height: 9)
            )
            
        } else if weather == "snow" || weather == "sleet" {
            image = UIImage.fontAwesomeIcon(
                name: .snowflake,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 14, height: 9)
            )
            
        } else if weather == "Clouds"  || weather == "partly-cloudy-day" || weather == "partly-cloudy-night" {
            image = UIImage.fontAwesomeIcon(
                name: .cloud,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 14, height: 9)
            )
        } else {
            image = UIImage.fontAwesomeIcon(
                name: .sun,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 14, height: 9)
            )
        }
        return image
    }

}
