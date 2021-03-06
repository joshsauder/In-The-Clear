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
    
    /**
     Sets up logout button
     - Parameters:
        - button: Logout Button
     */
    func setupLogoutButton(button: UIButton){
        button.backgroundColor = UIColor(red: 0.52, green: 0.11, blue: 0.52, alpha: 1.00)

        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 30)
    }
}
