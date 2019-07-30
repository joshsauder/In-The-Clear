//
//  CustomizeTripDetails.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/14/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class CustomizeTripDetails: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateView: UIView!
    var date: ((_ date: Date, _ cancel: Bool) -> ())?
    var tripDetails = tripDetailsModal().tripDetails
    var cities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setupView()
        setAddCell()
    }
    
    /**
     Sets up the date picker view
    */
    func setupView(){
        dateView.layer.cornerRadius = 10
        dateView.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
    }
    
    func setAddCell(){
        cities.insert("Add City", at: 1)
    }
    
    func setButtonImage(button: UIButton, imageString: String, size: Int){
        //Create Attachment
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = UIImage(named: imageString)
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: size, height: size)
        
        //Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        //Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        //Add image to mutable string
        completeText.append(attachmentString)
        
        //set up font
        button.titleLabel?.textAlignment = .center
        button.setAttributedTitle(completeText, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @objc func addButtonTapped(_ sender: UIButton){
        insertCityToTable()
    }
    
    func insertCityToTable(){
        //open GMSAutocomplete controllerand present
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
        
        //TODO: need to check new value was inputed
        let indexPath = IndexPath(row: cities.count-2, section: 0)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    /**
     On submit, set date to the selected date and dismiss the view.
     
     - parameters:
        - sender: The UIBUtton that is tapped
    */
    @IBAction func onSubmit(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    /**
     On cancel, dismiss the view and set the cancel variable to true.
     
     - parameters:
        - sender: The UIBUtton that is tapped
     */
    @IBAction func onCancel(_ sender: UIButton) {
        date?(Date(), true)
        dismiss(animated: true)
    }

}

extension CustomizeTripDetails: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDetails.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsTableViewCell", for: indexPath) as! TripDetailsTableViewCell
        tripCell.CityName.titleLabel?.text = cities[indexPath.row]
        tripCell.CityName.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        setButtonImage(button: tripCell.MoveButton, imageString: "baseline_reorder_black_36pt_2x", size: 20)
        return tripCell
    }
}

