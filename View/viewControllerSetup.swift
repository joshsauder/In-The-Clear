//
//  viewControllerSetup.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/6/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

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
     Disables all input buttons when loading a new route
    */
    func disableInputButtons(){
        //disable location buttons
        startButton.isEnabled = false
        destinationButton.isEnabled = false
        weatherList.isEnabled = false
        weatherList.alpha = 0.5
    }
    
    /**
     Sets up time and distance label
    */
    func timeLabelSetup(){
        
        //set up time and weather label
        timeAndDistanceView.isHidden = true
        timeAndDistanceView.backgroundColor = UIColor(white: 1, alpha: 1)
        timeAndDistanceView.layer.cornerRadius = 12
        //timeLabel.clipsToBounds = true
        timeAndDistanceView.layer.masksToBounds = true
        timeAndDistanceView.backgroundColor = UIColor(red:0.47, green:0.15, blue:0.50, alpha:1.0)
        
        //set up text allignment
        totalTimeLabel.textAlignment = .left
        drivingTimeLabel.textAlignment = .left
        totalDistanceLabel.textAlignment = .right
        
        //set up font size
        totalTimeLabel.font = UIFont.systemFont(ofSize: 13.0)
        drivingTimeLabel.font = UIFont.systemFont(ofSize: 13.0)
        totalDistanceLabel.font = UIFont.systemFont(ofSize: 13.0)
        
        //set dynamic font sizes
        totalTimeLabel.adjustsFontSizeToFitWidth = true
        totalDistanceLabel.minimumScaleFactor=0.5
        drivingTimeLabel.adjustsFontSizeToFitWidth = true
        drivingTimeLabel.minimumScaleFactor=0.5
        totalDistanceLabel.adjustsFontSizeToFitWidth = true
        totalDistanceLabel.minimumScaleFactor=0.5
        
        
        //set font color
        totalTimeLabel.textColor = .white
        drivingTimeLabel.textColor = .white
        totalDistanceLabel.textColor = .white
        

    }
    
    /**
     Configures the on map buttons
     - parameters:
        - button: The UIButton that is configured
        - imageString: The image name
        - size: Size of image
    */
    func configureMapButtons(button: UIButton, imageString: String, size: Int){
        
        button.isHidden = true
        button.backgroundColor = UIColor(white: 1, alpha: 1)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named: imageString)
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: size, height: size)
        
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        
        //set up font
        button.titleLabel?.textAlignment = .center
        button.setAttributedTitle(completeText, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //add shadow to button
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 1
        button.layer.shadowOpacity = 0.5
    }
    
    /**
     Sets up Google Maps, Set Time, and location buttons
    */
    func mapButtonsSetup(){
        
        configureMapButtons(button: openGoogleMaps, imageString: "icons8-google-maps-48", size: 30)
        configureMapButtons(button: setTime, imageString: "time", size: 30)
        configureMapButtons(button: myLocationButton, imageString: "baseline_my_location_black_36dp", size: 22)
    }

    /**
     Shows time and distance label and Google Maps Button. Enables weather List button.
     - parameters:
        - time: The total time it takes to travel the route
        - distance: The distance it takes to travel the route
    */
    func showButtonsAndLabels(drivingTime: String, totalTime: String, distance: Double){
        
        //enable time label
        self.drivingTimeLabel.text = "Driving Time: \(drivingTime)"
        self.totalTimeLabel.text = "Total Trip Time: \(totalTime)"
        self.totalDistanceLabel.text = "Driving Distance: \(String(format: "%.0f", distance)) Miles"
        
        self.timeAndDistanceView.isHidden = false
        
        //need to scale google maps icons/buttons for diffenent screen sizes
        if view.bounds.height > 800 && view.bounds.height < 900 {
            self.mapView.padding = UIEdgeInsetsMake(0, 0, 25, 0)
        }
        else if view.bounds.height >= 900{
            self.mapView.padding = UIEdgeInsetsMake(0, 0, 36, 0)
        }
        else{
            self.mapView.padding = UIEdgeInsetsMake(0, 0, 60, 0)
        }
        //enable weather list button
        self.weatherList.isEnabled = true
        self.weatherList.alpha = 1
        //enable google maps button
        self.openGoogleMaps.isHidden = false
        self.setTime.isHidden = false
        self.mapKey.isHidden = false
        
    }
    
    /**
    Shows location button, if enabled.
     Else, moves Google maps button and time button down
    */
    func showLocationButton(){
        //if location services are not enabled google maps and set time buttons down
        //else show location button
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                openMapsBottomContraints.constant = 10
            case .authorizedAlways, .authorizedWhenInUse:
                myLocationButton.isHidden = false
                openMapsBottomContraints.constant = 77
            }
        } else {
            openMapsBottomContraints.constant = 10
        }
    }
    /**
     Displays a UIAlert
     - parameters:
        - title: title of alert
        - message: the message of alert
    */
    func showAlert(title: String, message: String){
        //display alert based on tyle
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /**
     Displays a spinner while a process is executing
     - parameters:
        - view: The view in which the spinner will appear in
     */
    func showSpinner(view: UIView){
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIV = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        activityIV.startAnimating()
        activityIV.center = view.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIV)
            view.addSubview(spinnerView)
        }
        
        spinner = spinnerView
    }
    
    /**
     Removes the spinner from the superview
    */
    func stopSpinner(){
        DispatchQueue.main.async {
            self.spinner?.removeFromSuperview()
            self.spinner = nil
        }
    }
}


