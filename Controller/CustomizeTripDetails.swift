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
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var tripDetails = tripDetailsModal()
    var selectedIndex = IndexPath(row: 0, section: 0)
    weak var delegate: TripDetailsDetegate?
    var earliestTimes: [Date] = [Date()]
    var timeOffset: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupButton()
        configureTableView()
        getNewTimes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /**
     Adds city to trip details modal
     
     - parameters:
        - city: The city
        - loc: cities geocoordinates
        - index: index of city in table
    */
    func addCity(city: String, loc: CLLocation, index: Int) {
        tripDetails.cityStops.insert(city, at: index)
        tripDetails.startTimes.insert(Date(), at: index)
        tripDetails.cityLocations.insert(loc, at: index)
    }
    
    /**
     Gets the time from date picker and inserts it into the trip modal
     
     - parameters:
        - time: the date
    */
    func modifyTime(time: Date) {
        tripDetails.startTimes[selectedIndex.row] = time
        updateTimes()
    }
    
    /**
     Configures the table view on init
    */
    func configureTableView(){
        tripDetails = (delegate?.intializeLocationData())!
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.isEditing = false
        self.tableView.allowsSelection = true
        self.tableView.isUserInteractionEnabled = true
    }
    
    
    /**
     Opens Google Places view and adds selected city
     
     - parameters:
        - sender: The UI object interacted with
    */
    @IBAction func addButtonTapped(_ sender: Any){
        //open GMSAutocomplete controller and present
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    /**
     When edit button tapped, configures table to allow/disallow editting
     
     - parameters:
        - sender: The UI object interacted with
     */
    @IBAction func editButtonTapped(_ sender: Any) {
        
        self.tableView.isEditing = !self.tableView.isEditing
        
        if self.tableView.isEditing {
            addButton.isHidden = true
            editButton.setTitle("Done", for: .normal)
        } else {
            addButton.isHidden = false
            editButton.setTitle("Edit", for: .normal)
        }
        
    }
    
    /**
     Calls Here maps API service and gets the travel times
    */
    func getNewTimes(){
        getTravelTime(locations: tripDetails.cityLocations){ times in
            self.timeOffset = times
            self.updateTimes()
        }
    }
    
    /**
     Updates the earilest times array and reloads table data
    */
    func updateTimes(){
            self.earliestTimes = self.addTimes(times: timeOffset)
            self.tableView.reloadData()
    }
    
    /**
     Adds the time offsets to the start times to determine arrival time
     
     - parameters:
        - times: the time offsets
    */
    func addTimes(times: [Int]) -> [Date]{
        var retArray:[Date] = [Date()]
        if times.count > 0 {
            var tempArray = times
            //remove last from time array
            tempArray.removeLast()
            //recursive call
            retArray = addTimes(times: tempArray)
            let time = times[0]
            var date = Date()
            //if start time is less than earliest time, add time offset to earilest time
            //else add to start time
            //needed in the case where start time is greater than earliest time
            if Calendar.current.date(byAdding: .second, value: time, to: retArray[retArray.count - 1])! > Calendar.current.date(byAdding: .second, value: time, to: tripDetails.startTimes[retArray.count - 1])! {
                    
                date = Calendar.current.date(byAdding: .second, value: time, to: retArray[retArray.count - 1])!
            } else {
                date = Calendar.current.date(byAdding: .second, value: time, to: tripDetails.startTimes[retArray.count - 1])!
            }
            retArray.append(date)
        }
        return retArray
    }
    
    /**
     Inserts city into table
     
     - parameters:
        - index: the index to add row
    */
    func insertCityToTable(index: IndexPath){
        
        //TODO: need to check new value was inputed
        
        tableView.beginUpdates()
        tableView.insertRows(at: [index], with: .automatic)
        tableView.endUpdates()
        getNewTimes()
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
        //if index is in middle add arrival and departure, if first, add only departure time, else add only arrival time
        if indexPath.row < earliestTimes.count - 1 && indexPath.row != 0 {
            tripCell.DatePicker.minimumDate = earliestTimes[indexPath.row]
            let departureTime = tripCell.DatePicker.date.toString(dateFormat: "EE h:mm a")
            tripCell.departureTime.text = "Departure: \(departureTime)"
            let arrivalTime = earliestTimes[indexPath.row].toString(dateFormat: "EE h:mm a")
            tripCell.arrivalTime.text = "Arrival: \(arrivalTime)"
            
        } else if indexPath.row == 0 {
            tripCell.arrivalTime.text = ""
            tripCell.DatePicker.minimumDate = earliestTimes[indexPath.row]
            let timeText = tripCell.DatePicker.date.toString(dateFormat: "EE h:mm a")
            tripCell.departureTime.text = "Departure: \(timeText)"
        }
        else {
            tripCell.departureTime.text = ""
            if earliestTimes.count - 1 == indexPath.row {
                let timeText = earliestTimes[indexPath.row].toString(dateFormat: "EE h:mm a")
                tripCell.arrivalTime.text = "Arrival: \(timeText)"
            }
        }
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
            getNewTimes()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tripDetails.reorderItems(startIndex: sourceIndexPath.row, destIndex: destinationIndexPath.row)
        getNewTimes()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.beginUpdates()
        let cell = self.tableView.cellForRow(at: indexPath) as! TripDetailsTableViewCell
        //if index is already selected close else show uidatepicker
        if selectedIndex == indexPath {
            cell.DatePicker.isHidden = true
            selectedIndex = IndexPath()
        } else{
            cell.DatePicker.isHidden = false
            selectedIndex = indexPath
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

