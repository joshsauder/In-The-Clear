//
//  TripDetailsTableViewCell.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/26/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class TripDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CityName: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //createDatePicker()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
