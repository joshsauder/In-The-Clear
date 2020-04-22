//
//  TripHistoryController.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/20/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TripHistoryController: UITableViewController {
    
    var tripDataArray: [TripHistory] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripHistoryTableViewCell", for: indexPath) as! TripHistoryTableViewCell
        let entry = tripDataArray[indexPath.row]
        
        cell.OverviewLabel?.text = entry.OverviewLabel
        cell.DateLabel?.text = "days"
        
        return cell
    }
    
    func generateSnapshot(trip: TripData, scale: CGSize){
        let options = snapShotOptions(trip: trip, scale: scale)
        
        let snapshot = MKMapSnapshotter(options: options)
    }
    
    func snapShotOptions(trip: TripData, scale: CGSize) -> MKMapSnapshotter.Options{
        let options = MKMapSnapshotter.Options()
        
        let coordinates = trip.locations.map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        let region = MKCoordinateRegion(polyline.boundingMapRect)

        options.region = region
        options.scale = 2
        options.size = scale
        
        return options
    }
}
