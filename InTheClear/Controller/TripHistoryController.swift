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
        tableView.separatorStyle = .none
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
        
        cell.OverviewLabel?.text = entry.locations[0].city
        cell.DateLabel?.text = "days"
        
        generateSnapshot(trip: entry, scale: cell.MapImage.image!.size, completion: {(image) -> Void in
            cell.MapImage.image = image
        })
        
        return cell
    }
    
    func initTripHistory(){
        getUserTrips() {
            let manager = RealmManager()
            self.tripDataArray = manager.getTripHistory()
        }
    }
    
    func generateSnapshot(trip: TripData, scale: CGSize, completion: @escaping (UIImage) -> ()){
        let coordinates = Array(trip.locations).map {
            CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
        }
        
        let options = snapShotOptions(trip: trip, scale: scale, coordinates: coordinates)
        
        let snapshot = MKMapSnapshotter(options: options)
        
        snapshot.start() { snap, error in
            guard let snap = snap else {
                return
            }
            
            completion(self.drawLineOnImage(snapshot: snap, coordinations: coordinates, scale: scale))
        }
    }
    
    func snapShotOptions(trip: TripData, scale: CGSize, coordinates: [CLLocationCoordinate2D]) -> MKMapSnapshotter.Options{
        let options = MKMapSnapshotter.Options()
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        
        let region = MKCoordinateRegion(polyline.boundingMapRect)

        options.region = region
        options.scale = 2
        options.size = scale
        
        return options
    }
    
    func drawLineOnImage(snapshot: MKMapSnapshotter.Snapshot, coordinations: [CLLocationCoordinate2D], scale: CGSize) -> UIImage {
        let image = snapshot.image
        UIGraphicsBeginImageContextWithOptions(scale, true, 0)
        image.draw(at: CGPoint.zero)

        // get the context for CoreGraphics
        let context = UIGraphicsGetCurrentContext()

        // set stroking width and color of the context
        context!.setLineWidth(2.0)
        context!.setStrokeColor(UIColor.orange.cgColor)

        context!.move(to: snapshot.point(for: coordinations[0]))
        for i in 0...coordinations.count-1 {
          context!.addLine(to: snapshot.point(for: coordinations[i]))
          context!.move(to: snapshot.point(for: coordinations[i]))
        }

        context!.strokePath()

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return resultImage!
    }
}
