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
    
    func setupSegment(){
        
        dateFormatSwitch.setTitle("Date", forSegmentAt: 0)
        dateFormatSwitch.setTitle("Interval", forSegmentAt: 1)
    }
    
    @IBAction func datePickerChange(_ sender: Any) {
        departureTime.text = "Departure Time: " + DatePicker.date.toString(dateFormat: "EE h:mm a")
        cellData?.modifyTime(time: DatePicker.date)
    }
    
    @IBAction func switchDateFormat(_ sender: Any) {
        let index = dateFormatSwitch.selectedSegmentIndex
        if index == 0 {
            DatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        }else {
            DatePicker.datePickerMode = UIDatePickerMode.countDownTimer
        }
    }
}


extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
