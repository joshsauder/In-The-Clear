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

protocol CellDataDelegate: class {
    func modifyTime(time: Date)
}


class CustomizeTripDetails: UIViewController, CellDataDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateView: UIView!
    var tripDetails = tripDetailsModal()
    var cities: [String] = []
    var selectedIndex = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripDetails.cityStops = cities
        tripDetails.startTimes = [Date()]
        setupView()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addCity(city: String, index: Int) {
        cities.insert(city, at: index)
        tripDetails.cityStops.insert(city, at: index)
        tripDetails.startTimes.insert(Date(), at: index)
    }
    
    func modifyTime(time: Date) {
        tripDetails.startTimes[selectedIndex.section] = time
    }
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.isEditing = true
        self.tableView.allowsSelection = true
        self.tableView.isUserInteractionEnabled = true
        setAddCityCell()
    }
    
    
    func setAddCityCell(){
        cities.insert("Add City", at: 1)
    }
    
    
    @objc func addButtonTapped(){
        //open GMSAutocomplete controllerand present
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func insertCityToTable(){
        
        //TODO: need to check new value was inputed
        
        tableView.beginUpdates()
        tableView.insertSections(IndexSet(integer: selectedIndex.section), with: .automatic)
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
        dismiss(animated: true)
    }

}

extension CustomizeTripDetails: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cities.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
        
            let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsTableViewCell", for: indexPath) as! TripDetailsTableViewCell
            tripCell.CityName.setTitle(cities[indexPath.section], for: .normal)
            if(cities[indexPath.section] != "Add City"){
                tripCell.CityName.isEnabled = false
            }
            //tripCell.CityName.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
            return tripCell
        }
        else if indexPath.row == 1 {
            let tripCell = tableView.dequeueReusableCell(withIdentifier: "TripDetailsTimeTableViewCell", for: indexPath) as! TripDetailsTimeTableViewCell
            tripCell.cellData = self
            return tripCell
        }
        //need to change this
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.section)
            tripDetails.removeItems(index: indexPath.section)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = cities[sourceIndexPath.section]
        cities.remove(at: sourceIndexPath.section)
        cities.insert(item, at: destinationIndexPath.section)
        tripDetails.reorderItems(startIndex: sourceIndexPath.section, destIndex: destinationIndexPath.section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.beginUpdates()
        
        if indexPath.row == 0 {
            selectedIndex = indexPath
            let cell = self.tableView.cellForRow(at: indexPath) as! TripDetailsTableViewCell
            if cell.CityName.currentTitle == "Add City" {
                addButtonTapped()
                tableView.deselectRow(at: selectedIndex, animated: false)
            }
        }
        
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == selectedIndex.section && indexPath.row == 1 {
            return 140
        }else if indexPath.row == 1 {
            return 0
        }
        return 44
    }
}

