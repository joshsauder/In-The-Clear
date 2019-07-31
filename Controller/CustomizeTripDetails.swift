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
    var tripDetails = tripDetailsModal().tripDetails
    var cities: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        setupView()
        setAddCell()
    }
    
    
    func setAddCell(){
        cities.insert("Add City", at: 1)
    }
    
    
    @objc func addButtonTapped(_ sender: UIButton){
        //open GMSAutocomplete controllerand present
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func insertCityToTable(){
        
        //TODO: need to check new value was inputed
        let indexPath = IndexPath(row: cities.count-2, section: 0)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    @objc func removeButtonTapped(_ sender: UIButton){
        
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
        dismiss(animated: true)
    }

}

extension CustomizeTripDetails: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsTableViewCell", for: indexPath) as! TripDetailsTableViewCell
        tripCell.CityName.titleLabel?.text = cities[indexPath.row]
        tripCell.CityName.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        self.setButtonImage(button: tripCell.MoveButton, imageString: "baseline_reorder_black_36pt_2x", size: 20)
        self.setButtonImage(button: tripCell.CancelButton, imageString: "baseline_clear_black_36pt_2x", size: 20)
        tripCell.CancelButton.addTarget(self, action: #selector(removeButtonTapped(_:)), for: .touchUpInside)
        return tripCell
    }
}

