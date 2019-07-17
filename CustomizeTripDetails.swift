//
//  CustomizeTripDetails.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/14/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class CustomizeTripDetails: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateView: UIView!
    var date: ((_ date: Date) -> ())?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createDatePicker()
    }
    
    func setupView(){
        dateView.layer.cornerRadius = 10
        dateView.layer.masksToBounds = true
    }
    
    func createDatePicker(){
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        
        //set min and max date values for date picker
        let minDate = Calendar.current.date(byAdding: .day, value: .zero, to: Date())
        let maxDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        date?(datePicker.date)
        dismiss(animated: true)
    }
    
}
