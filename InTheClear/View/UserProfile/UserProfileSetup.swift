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
}
