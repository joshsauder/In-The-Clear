//
//  TripDetailsTimeTableViewCell.swift
//  InTheClear
//
//  Created by Josh Sauder on 8/2/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class TripDetailsTimeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //createDatePicker()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /**
     Configure the date picker
     */
        func createDatePicker(){
    
            DatePicker.datePickerMode = UIDatePickerMode.dateAndTime
    
            //set min and max date values for date picker
            let minDate = Calendar.current.date(byAdding: .day, value: .zero, to: Date())
            let maxDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())
            DatePicker.minimumDate = minDate
            DatePicker.maximumDate = maxDate
    
        }
    
    
}
