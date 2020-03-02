//
//  CustomizeTripDetailsView.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/29/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

extension CustomizeTripDetails {
    
    /**
     Sets up the date picker view
     */
    internal func setupView(){
        dateView.layer.cornerRadius = 10
        dateView.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
    }
    
    /**
     Sets up add and edit buttons
    */
    internal func setupButton(){
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        
        var image = UIImage(named: "addIcon")
        image = image?.resize(targetSize: CGSize(width: 21, height: 21))
        image = image?.withRenderingMode(.alwaysTemplate)
    
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .white
    }
    
    /**
        Displays a UIAlert
        - parameters:
           - title: title of alert
           - message: the message of alert
       */
       internal func showAlert(title: String, message: String){
           //display alert based on tyle
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
           
       }
}

extension TripDetailsTableViewCell {
    
    /**
     Sets each cell color and border
    */
    internal func setCellColor(){
        
        self.contentView.backgroundColor = UIColor(red:0.47, green:0.15, blue:0.50, alpha:1.0)
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 3
        self.contentView.layer.borderColor = UIColor.white.cgColor
    }
    
    /**
     Sets each cells label color to white
    */
    internal func setLabelColor(){
        self.arrivalTime.textColor = .white
        self.departureTime.textColor = .white
        self.CityName.textColor = .white
    }
    
    /**
     Sets the cells fonts to be adjustable
    */
    internal func setLabelFont(){
        //set dynamic font sizes
        self.arrivalTime.adjustsFontSizeToFitWidth = true
        self.arrivalTime.minimumScaleFactor=0.5
        self.departureTime.adjustsFontSizeToFitWidth = true
        self.departureTime.minimumScaleFactor=0.5
        self.CityName.adjustsFontSizeToFitWidth = true
        self.CityName.minimumScaleFactor=0.5
        
    }
    
}


