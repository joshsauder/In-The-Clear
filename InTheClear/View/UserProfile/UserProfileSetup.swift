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
    
    func premiumLabelSetup(){
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle")
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        //Create string with attachment
        let firstAttachmentString = NSAttributedString(attachment: imageAttachment)
        let secondAttachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let firstText = NSMutableAttributedString(string: " Plan a trip up to 5 days in advance.")
        let secondText = NSMutableAttributedString(string: " Add stops during your trip.")
        //Add image to mutable string
        firstText.insert(firstAttachmentString, at: 0)
        secondText.insert(secondAttachmentString, at: 0)
        self.FirstPremiumBenefitLabel.attributedText = firstText
        self.SecondPremiumBenefitLabel.attributedText = secondText
    }
}
