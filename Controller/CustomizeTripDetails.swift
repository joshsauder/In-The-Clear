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
import CoreLocation

protocol CellDataDelegate: class {
    func modifyTime(time: Date)
}


class CustomizeTripDetails: UIViewController, CellDataDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateView: UIView!
    var tripDetails = tripDetailsModal()
    var selectedIndex = IndexPath(row: 0, section: 0)
    weak var delegate: TripDetailsDetegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addCity(city: String, loc: CLLocation, index: Int) {
        tripDetails.cityStops.insert(city, at: index)
        tripDetails.startTimes.insert(Date(), at: index)
        tripDetails.cityLocations.insert(loc, at: index)
    }
    
    func modifyTime(time: Date) {
        tripDetails.startTimes[selectedIndex.row] = time
    }
    
    func configureTableView(){
        tripDetails = (delegate?.intializeLocationData())!
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.isEditing = true
        self.tableView.allowsSelection = true
        self.tableView.isUserInteractionEnabled = true
        setAddCityCell()
    }
    
    
    func setAddCityCell(){
        tripDetails.cityStops.insert("Add City", at: 1)
    }
    
    
    func addButtonTapped(){
        //open GMSAutocomplete controllerand present
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func insertCityToTable(){
        
        //TODO: need to check new value was inputed
        
        tableView.beginUpdates()
        tableView.insertRows(at: [selectedIndex], with: .automatic)
        tableView.endUpdates()
    }
    
    /**
     On submit, set date to the selected date and dismiss the view.
     
     - parameters:
        - sender: The UIBUtton that is tapped
    */
    @IBAction func onSubmit(_ sender: UIButton) {
        delegate?.recieveLocationData(tripDetials: tripDetails)
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

extension CustomizeTripDetails: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDetails.cityStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsTableViewCell", for: indexPath) as! TripDetailsTableViewCell
        tripCell.CityName.text = tripDetails.cityStops[indexPath.row]
        tripCell.cellData = self

        return tripCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tripDetails.removeItems(index: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            //will need to prevent target city from being removed
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tripDetails.reorderItems(startIndex: sourceIndexPath.row, destIndex: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.beginUpdates()
        let cell = self.tableView.cellForRow(at: indexPath) as! TripDetailsTableViewCell
        if selectedIndex == indexPath {
            cell.DatePicker.isHidden = true
            selectedIndex = IndexPath()
        } else{
            cell.DatePicker.isHidden = false
            selectedIndex = indexPath
            if cell.CityName.text! == "Add City" {
                addButtonTapped()
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndex && indexPath.row != tripDetails.cityStops.count - 1 {
            return 184
        }
        return 44
    }
}

