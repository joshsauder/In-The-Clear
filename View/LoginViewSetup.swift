//
//  LoginViewSetup.swift
//  InTheClear
//
//  Created by Josh Sauder on 2/5/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

extension LoginController {
    
    /**
     Styles the Submit Button
     
     - Parameters:
        - button: The UIButton to style
     */
    func createButton(button: UIButton){
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        //set background and text color
        button.setTitleColor(UIColor(red:0.47, green:0.15, blue:0.50, alpha:1.0), for: .normal)
        button.layer.backgroundColor = UIColor.white.cgColor
        
        //set shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 1.0
    }

    /**
    Disables a button
    
    - Parameters:
       - button: The UIButton to disable
    */
    func disableButton(button: UIButton){
        //submit button should be disabled on init
        button.isEnabled = false
    }
    
    /**
     Initializes the animating arrows location
     */
    func initArrowPosition(){
        self.SunArrowLeadingConstraint.constant -= view.bounds.width
        self.StormArrowTrailingContstraint.constant += view.bounds.width
    }
    
    /**
    Shows the animating arrows.
    */
    func showArrows(){
        UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.SunArrowLeadingConstraint.constant += self.view.bounds.width
            self.StormArrowTrailingContstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

