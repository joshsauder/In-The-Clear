//
//  UserProfileSetup.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/30/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

extension UserProfile {
    
    func setupLabels(label: UILabel, text: String){
        label.text = text
        label.font.withSize(20)
        label.textColor = .white
    }
    
    func setupLogoutButton(button: UIButton){
        button.backgroundColor = UIColor(red:0.47, green:0.15, blue:0.50, alpha:1.0)

        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 20)
    }
}
