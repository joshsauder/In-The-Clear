//
//  LoginViewSetup.swift
//  InTheClear
//
//  Created by Josh Sauder on 2/5/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

protocol Login {
    func createButton(button: UIButton)
}

extension Login {
    func createButton(button: UIButton){
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        //set background and text color
        button.setTitleColor(UIColor(red:0.47, green:0.15, blue:0.50, alpha:1.0), for: .normal)
        button.layer.backgroundColor = UIColor.white.cgColor
        
        //set shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 1.0
        
    }
}

extension LoginController : Login {}
extension RegisterViewController : Login {}
extension StartViewController : Login {}
