//
//  TripDetailsTableViewCell.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/26/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class TripDetailsTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var dateFormatSwitch: UISegmentedControl!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    
    weak var cellData: CellDataDelegate?
    
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
    
    /**
     When the date picker is changed, updated the trip modal
     
     - parameters:
        - sender: the ui object interacted with
    */
    @IBAction func datePickerChange(_ sender: Any) {
        departureTime.text = "Departure Time: " + DatePicker.date.toString(dateFormat: "EE h:mm a")
        cellData?.modifyTime(time: DatePicker.date)
    }
    
}

extension Date
{
    /**
     Formats a Date into a string
     
     - parameters:
        - format: The format the date needs to be in
    */
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
