//
//  WeatherTableViewCell.swift
//  InTheClear
//
//  Created by Josh Sauder on 10/25/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer?.frame = self.bounds
    }
    
    /*
     Function allows for cells to have array of color (gradient)
    */
    func colorCell(firstColor: UIColor, secondColor:UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.zPosition = -1
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
}
