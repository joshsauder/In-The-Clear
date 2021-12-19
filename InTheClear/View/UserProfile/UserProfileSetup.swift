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
        imageAttachment.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
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
        self.FirstPremiumBenefitLabel.textColor = .white
        self.SecondPremiumBenefitLabel.textColor = .white
    }
    
    func premiumViewSetup(){
        let colorOne = UIColor(red:0.47, green:0.15, blue:0.50, alpha:1.0)
        let colorTwo = UIColor(red:0.88, green:0.19, blue:0.88, alpha:1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.PremiumView.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.zPosition = -1
        self.PremiumView.layer.addSublayer(gradientLayer)
        
        self.PremiumView.layer.cornerRadius = 10
        self.PremiumView.layer.masksToBounds = true
    }
}
