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
        tableView.separatorStyle = .none
        
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
        cell.weatherImage.image = weatherImage(weather: entry.weather)
        cell.cityLabel.text = entry.city
        cell.tempLabel.text = "\(Int(entry.highTemp.rounded()))℉"
        cell.conditionLabel.text = entry.condition.capitalized
        cell.backgroundColor = cellColor(weather: entry.weather)
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 6
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
            color = UIColor(red:0.08, green:0.79, blue:0.38, alpha:1.0)
            
        } else if weather == "Thunderstorm" {
            color = UIColor(red:0.88, green:0.11, blue:0.33, alpha:1.0)
            
        } else if weather == "Snow" {
            color = UIColor(red:0.28, green:0.42, blue:0.87, alpha:1.0)
            
        } else if weather == "Clouds" {
            color = UIColor(red:0.63, green:0.62, blue:0.62, alpha:1.0)
            
        }
        else {
            color = UIColor(red:0.91, green:0.76, blue:0.30, alpha:1.0)
        }
        
        return color
    }
    
    func weatherImage(weather: String) -> UIImage {
        var image = UIImage()
        if weather == "Rain" {
            image = UIImage.fontAwesomeIcon(
                name: .tint,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 12, height: 9)
            )
        } else if weather == "Thunderstorm" {
            image = UIImage.fontAwesomeIcon(
                name: .bolt,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 12, height: 9)
            )
            
        } else if weather == "Snow" {
            image = UIImage.fontAwesomeIcon(
                name: .snowflake,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 12, height: 9)
            )
            
        } else if weather == "Clouds" {
            image = UIImage.fontAwesomeIcon(
                name: .cloud,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 12, height: 9)
            )
        } else {
            image = UIImage.fontAwesomeIcon(
                name: .sun,
                style: .solid,
                textColor: .white,
                size: CGSize(width: 12, height: 9)
            )
        }
        return image
    }

}
