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
    
    func setupUpgradeButton(button: UIButton, paid: Bool){
        if paid {
            button.backgroundColor = UIColor.green
            
            button.setTitle("\(UIImage(systemName: "checkmark.circle.fill")) You're a Premium Member", for: .normal)
        } else {
            button.backgroundColor = UIColor(red: 0.52, green: 0.11, blue: 0.52, alpha: 1.00)
            button.setTitle("Upgrade to Premium", for: .normal)
        }
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 30)
    }
    
    func premiumLabelSetup(){
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle")
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        //Create string with attachment
        let firstAttachmentString = NSAttributedString(attachment: imageAttachment)
        let secondAttachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let firstText = NSMutableAttributedString(string: "Plan a trip up to 5 days in advance.")
        let secondText = NSMutableAttributedString(string: "Add stops during your trip.")
        //Add image to mutable string
        firstAttachmentString.append(firstText)
        secondAttachmentString.append(secondText)
        self.FirstPremiumBenefitLabel.attributedText = firstAttachmentString
        self.SecondPremiumBenefitLabel.attributedText = secondAttachmentString
    }
}
