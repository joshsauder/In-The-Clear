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
    func setupView(){
        dateView.layer.cornerRadius = 10
        dateView.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
    }
    
    
    func setupButton(){
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        
        var image = UIImage(named: "addIcon")
        image = image?.resize(targetSize: CGSize(width: 21, height: 21))
        image = image?.withRenderingMode(.alwaysTemplate)
    
        addButton.setImage(image, for: .normal)
        addButton.tintColor = .white
    }
}


