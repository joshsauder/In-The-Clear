//
//  CustomizeTripDetailsView.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/29/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

extension CustomizeTripDetails {
    
    func setLabelImage(imageString: String, labelString: String, size: Int) -> NSMutableAttributedString{
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named: imageString)
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: size, height: size)
        
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        
        let textAfterIcon = NSMutableAttributedString(string: " " + labelString)
        completeText.append(textAfterIcon)
        
        return completeText
    }
    
    /**
     Sets up the date picker view
     */
    func setupView(){
        dateView.layer.cornerRadius = 10
        dateView.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
    }
}
