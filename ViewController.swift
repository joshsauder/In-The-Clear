//
//  ViewController.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/3/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

enum Location {
    case startLocation
    case destinationLocation
}

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var times: [Date] = []
    var temps: [String] = []
    var conditions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationAuthorization()
        setupMap()
    }
    
    func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151, zoom: 13.0)
        mapView.camera = camera
        mapView.delegate = self
        mapView?.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
    }
    
    func locationAuthorization(){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let locationTujuan = CLLocation(latitude: 37.784023631590777, longitude: -122.40486681461333)
        
        createMarker(titleMarker: "Lokasi Tujuan", latitude: locationTujuan.coordinate.latitude, longitude: locationTujuan.coordinate.longitude)
        
        createMarker(titleMarker: "Lokasi Aku", latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        drawPath(startLocation: location!, endLocation: locationTujuan)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        mapView.isMyLocationEnabled = true
        mapView.selectedMarker = nil
        return false
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func originStartLocation(_ sender: UIButton) {
        
        let autoCompleteControl = GMSAutocompleteViewController()
        autoCompleteControl.delegate = self
        
        //given location
        locationSelected = .startLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteControl, animated: true, completion: nil)
        
    }
    
    @IBAction func openDestinationLocation(_ sender: UIButton){
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        //given location
        locationSelected = .destinationLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    @IBAction func showDirection(_ sender: UIButton){
        
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
    }
    
    //function to create directions path from start to end
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let pathURL = url.PATH_URL + origin + "&destination=" + destination + "&mode=driving"
    
        Alamofire.request(pathURL, method: .get).validate().responseJSON { response in
            
                print(response.request as Any)
                
                print(response.request as Any)  // original URL request
                print(response.response as Any) // HTTP URL response
                print(response.data as Any)     // server data
                print(response.result as Any)
                
                let json = JSON(response.data!)
                let routes = json["routes"].arrayValue
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.mapView
                }
            
        }
    }
    
    // function to create a marker on map
    func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.map = mapView
    }
    
}

