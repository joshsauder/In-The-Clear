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
        weatherList.layer.shadowOffset = CGSize(width: 5, height: 5)
        weatherList.layer.shadowRadius = 5
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
        timeLabel.layer.cornerRadius = 5
        timeLabel.clipsToBounds = true
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        timeLabel.adjustsFontForContentSizeCategory = true
        timeLabel.layer.cornerRadius = 5
        timeLabel.clipsToBounds = true
        
        //add shadow to time and weather label
        timeLabel.layer.shadowColor = UIColor.black.cgColor
        timeLabel.layer.masksToBounds = false
        timeLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        timeLabel.layer.shadowRadius = 5
        timeLabel.layer.shadowOpacity = 1.0
    }
    
    /**
     Sets up Google Maps button
    */
    func googleMapsButtonSetup(){
        
        openGoogleMaps.isHidden = true
        openGoogleMaps.backgroundColor = UIColor(white: 1, alpha: 1)
        openGoogleMaps.layer.cornerRadius = 5
        openGoogleMaps.clipsToBounds = true
        
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named:"icons8-google-maps-48")
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 25, height: 25)
        
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        //Add your text to mutable string
        let  textAfterIcon = NSMutableAttributedString(string: "Open In Google Maps")
        completeText.append(textAfterIcon)
        
        //set up font
        openGoogleMaps.setTitleColor(UIColor.black, for: .normal)
        openGoogleMaps.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        openGoogleMaps.titleLabel?.textAlignment = .center
        openGoogleMaps.setAttributedTitle(completeText, for: .normal)
        openGoogleMaps.titleLabel?.adjustsFontForContentSizeCategory = true
        
        //add shadow to button
        openGoogleMaps.layer.shadowColor = UIColor.black.cgColor
        openGoogleMaps.layer.masksToBounds = false
        openGoogleMaps.layer.shadowOffset = CGSize(width: 3, height: 3)
        openGoogleMaps.layer.shadowRadius = 5
        openGoogleMaps.layer.shadowOpacity = 1.0
    }
    /**
     Shows time and distance label and Google Maps Button. Enables weather List button.
    */
    func showButtonsAndLabels(){
        
        //enable time label
        self.timeLabel.text = "Time: \(time)  Distance: \(self.totalDistance)"
        self.timeLabel.isHidden = false
        self.mapView.padding = UIEdgeInsetsMake(0, 0, 25, 0)
        //enable weather list button
        self.weatherList.isEnabled = true
        self.weatherList.alpha = 1
        //enable google maps button
        self.openGoogleMaps.isHidden = false
        
    }
}
