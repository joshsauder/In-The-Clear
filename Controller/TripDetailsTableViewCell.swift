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
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var MoveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createDatePicker()
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
