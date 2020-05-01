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

