//
//  TripHistoryTableCell.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/20/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import UIKit

class TripHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var OverviewLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var StopsLabel: UILabel!
    @IBOutlet weak var MapImage: UIImageView!
    var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
