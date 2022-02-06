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
     Sets up Premium label
     */
    func premiumLabelSetup(){
        updateLabel()
        updateLegalText()
        
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
    
    /**
     Colors the premium view
     */
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
        
        if UIScreen.main.bounds.height < 700 {
            self.ProfileToPremiumConstraint.constant = 13
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     Updates the Premium Label
     */
    func updateLabel(){
        if self.user.paid {
            self.PayLabel.text = "Your Premium Benefits"
        } else {
            self.PayLabel.text = "Join for $5 per year"
        }
    }
    
    /**
     Updates the legal text view
     */
    func updateLegalText(){
        let attributedString = NSMutableAttributedString(string: "Terms of Service and Privacy Policy")
        
        // Add Link
        attributedString.addAttribute(.link, value: "https://intheclearapp.com/termsOfService", range: NSRange(location: 0, length: 16))
        attributedString.addAttribute(.link, value: "https://intheclearapp.com/privacy", range: NSRange(location: 21, length: 14))
        
        //Update Font
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(location: 0, length: 16))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 16, length: 5))
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 17), range: NSRange(location: 21, length: 14))
        
        //Update Color
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: 35))

        
        self.LegalTextView.attributedText = attributedString
        self.LegalTextView.backgroundColor = .clear
        self.LegalTextView.linkTextAttributes = [.foregroundColor: UIColor.white]
    }
}
