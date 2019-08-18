//
//  WeatherMenuView.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/25/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

extension WeatherTableViewCell {
    
    /**
     Function allows for cells to have array of color (gradient)
     
     - parameters:
     - firstColor: The lighter UIColor
     - secondColor: The darker UIColor
     */
    internal func colorCell(firstColor: UIColor, secondColor:UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.zPosition = -1
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
}

extension UIImage {
    //needed to resize each UIImage to UIImageView size
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
}

extension UIImageView {
    //sets each image to a white color
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
