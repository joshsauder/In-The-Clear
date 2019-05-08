//
//  viewControllerSetup.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/6/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    /**
     Sets up map key
    */
    func mapkeySetup(){
        
        //hide map key
        mapKey.isHidden = true
        
        //add shadow to map key
        mapKey.layer.shadowColor = UIColor.black.cgColor
        mapKey.layer.masksToBounds = false
        mapKey.layer.shadowOffset = CGSize(width: 1, height: 1)
        mapKey.layer.shadowRadius = 2
        mapKey.layer.shadowOpacity = 1.0
    }
    /**
     Sets up weathet list button
    */
    func weatherListButtonSetup() {
        
        //set up weatherButton
        weatherList.layer.cornerRadius = 5
        weatherList.clipsToBounds = true
        weatherList.setTitle("Expanded City List" , for: .normal)
        weatherList.setTitleColor(UIColor.black, for: .normal)
        weatherList.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        weatherList.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        //add shadow to button
        weatherList.layer.shadowColor = UIColor.black.cgColor
        weatherList.layer.masksToBounds = false
        weatherList.layer.shadowOffset = CGSize(width: 3, height: 3)
        weatherList.layer.shadowRadius = 3
        weatherList.layer.shadowOpacity = 1.0
        
        //disable button at start
        weatherList.isEnabled = false
        weatherList.alpha = 0.5
        
    }
    
    /**
     Sets up time and distance label
    */
    func timeLabelSetup(){
        
        //set up time and weather label
        timeLabel.isHidden = true
        timeLabel.backgroundColor = UIColor(white: 1, alpha: 1)
        timeLabel.layer.cornerRadius = 15
        //timeLabel.clipsToBounds = true
        timeLabel.layer.masksToBounds = true
        timeLabel.textAlignment = .center
        //timeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        timeLabel.font = UIFont.systemFont(ofSize: 22.0)
        timeLabel.adjustsFontForContentSizeCategory = true
        

    }
    
    /**
     Sets up Google Maps button
    */
    func googleMapsButtonSetup(){
        
        openGoogleMaps.isHidden = true
        openGoogleMaps.backgroundColor = UIColor(white: 1, alpha: 1)
        openGoogleMaps.layer.cornerRadius = 0.5 * openGoogleMaps.bounds.size.width
        openGoogleMaps.clipsToBounds = true
        
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"icons8-google-maps-48")
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 30, height: 30)
        
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        
        //set up font
        openGoogleMaps.titleLabel?.textAlignment = .center
        openGoogleMaps.setAttributedTitle(completeText, for: .normal)
        openGoogleMaps.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //add shadow to button
        openGoogleMaps.layer.shadowColor = UIColor.black.cgColor
        openGoogleMaps.layer.masksToBounds = false
        openGoogleMaps.layer.shadowOffset = CGSize(width: 0, height: 1)
        openGoogleMaps.layer.shadowRadius = 1
        openGoogleMaps.layer.shadowOpacity = 0.5
    }
    /**
     Shows time and distance label and Google Maps Button. Enables weather List button.
     - parameters:
        - time: The total time it takes to travel the route
    */
    func showButtonsAndLabels(time: String){
        
        //enable time label
        self.timeLabel.text = "Time: \(time)  Distance: \(self.totalDistance)"
        self.timeLabel.isHidden = false
        
        //need to scale google maps icons/buttons for diffenent screen sizes
        if view.bounds.height > 800 {
            self.mapView.padding = UIEdgeInsetsMake(0, 0, 25, 0)
        }
        else{
            self.mapView.padding = UIEdgeInsetsMake(0, 0, 60, 0)
        }
        //enable weather list button
        self.weatherList.isEnabled = true
        self.weatherList.alpha = 1
        //enable google maps button
        self.openGoogleMaps.isHidden = false
        
        self.mapKey.isHidden = false
        
    }
}


