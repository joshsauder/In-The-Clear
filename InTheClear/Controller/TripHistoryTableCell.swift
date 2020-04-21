//
//  TripHistoryTableCell.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/20/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import UIKit

class TripHistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var OverviewLabel: UILabel!
    var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
