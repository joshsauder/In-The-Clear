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
    
    var tripDataArray: [TripData] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable(tableView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initTripHistory()
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
        
        cell.OverviewLabel?.text = "\(entry.locations.first?.city ?? "") - \(entry.locations.last?.city ?? "")"
        cell.DateLabel?.text = "\(determineDays(date: entry.createdAt)) days ago"
        cell.StopsLabel?.text = "Stops -"
        
        if(entry.locations.count > 2 ){
            var stopString = ""
            
            for (i, loc) in entry.locations.enumerated() {
                if(i != 0 && i < entry.locations.count - 1){
                    stopString += " \(loc.city),"
                }
            }
            cell.StopsLabel?.text! += stopString.prefix(stopString.count - 1)
        } else { cell.StopsLabel?.text! += " None" }
        
        generateSnapshot(trip: entry, size: cell.MapImage.bounds.size, completion: {(image) -> Void in
            cell.MapImage.image = image
        })
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = tripDataArray[indexPath.row]
        showPreviousRoute(trip: entry)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader(title: "Past Trips", width: tableView.frame.width)
    }
    
    /**
     Fetches trip history  from Realm
     */
    func initTripHistory(){
        let manager = RealmManager()
        self.tripDataArray = manager.getTripHistory()
        self.tableView.reloadData()
    }
    
    /**
     Generates a snapshot image of start and end location on map
     - parameters:
        - trip: The trip we need a snapshot of
        - size: Size of image
        - completion - Returns the snapshot on completion-
     */
    func generateSnapshot(trip: TripData, size: CGSize, completion: @escaping (UIImage) -> ()){
        let coordinates = Array(trip.locations).map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        let options = snapShotOptions(size: size, coordinates: coordinates)
        
        let snapshot = MKMapSnapshotter(options: options)
        
        //updating UI so run in main thread
        DispatchQueue.main.async {
            snapshot.start() { snap, error in
                guard let snap = snap else {
                    return
                }
                
                let image = UIGraphicsImageRenderer(size: options.size).image { _ in
                    snap.image.draw(at: .zero)

                    let pinView = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                    
                    for(index, item) in coordinates.enumerated() {
                        
                        pinView.pinTintColor = index == 0 || index == coordinates.count - 1 ? MKPinAnnotationView.redPinColor() : MKPinAnnotationView.greenPinColor()
                        
                        let pinImage = pinView.image
                        var point = snap.point(for: item)
                        
                        point.x -= pinView.bounds.width / 2
                        point.y -= pinView.bounds.height / 2
                        point.x += pinView.centerOffset.x
                        point.y += pinView.centerOffset.y
                        pinImage?.draw(at: point)
                    }
                    
                }
                
                completion(image)
            }
        }
    }
    
    /**
     Sets up the snapshot options/settings
     - parameters:
       - size: Size of image
       - coordinates: Array of coordinates from the given trip
     - returns: The snapshot options
    */
    func snapShotOptions(size: CGSize, coordinates: [CLLocationCoordinate2D]) -> MKMapSnapshotter.Options{
        let options = MKMapSnapshotter.Options()
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        var region = MKCoordinateRegion(polyline.boundingMapRect)
        region.span.latitudeDelta += 0.8
        region.span.longitudeDelta += 0.8

        options.region = region
        //retina resolution
        options.scale = 2
        options.size = size
        
        return options
    }
    
    /**
     Determines the number of days since the trip was searched for
     - parameters:
        - date: The date the trip was searched for
     - returns: The number of days
     */
    func determineDays(date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    
    /**
     Shows the selected route from the trip history table on the map
     - parameters:
        - trip: The selected trip
     */
    func showPreviousRoute(trip: TripData){
        let mainVc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        let tripDetails = tripDetailsModal()
        
        for (index, item) in trip.locations.enumerated(){
            let location = CLLocation(latitude: item.latitude, longitude: item.longitude)
            tripDetails.addCity(city: item.city, loc: location, index: index)
        }
        
        mainVc.locationStart = tripDetails.cityLocations[0]
        mainVc.locationEnd = tripDetails.cityLocations.last!
        mainVc.userTripDetails = tripDetails
        self.present(mainVc, animated: true, completion: nil)
        
        //must be set after presenting.
        mainVc.startLocation.text = tripDetails.cityStops[0]
        mainVc.destinationLocation.text = tripDetails.cityStops.last!
        
        //constrain time and distance label view to super view instead of safe view
        mainVc.BottomLabelConstraint.isActive = false
        mainVc.BottomLabelConstraint = mainVc.view.bottomAnchor.constraint(equalTo: mainVc.timeAndDistanceView.bottomAnchor, constant: -10)
        mainVc.BottomLabelConstraint.isActive = true
        
        mainVc.showTimePopup(UIButton())
        
    }
}
