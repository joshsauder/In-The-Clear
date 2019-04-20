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
import FontAwesome_swift

enum Location {
    case startLocation
    case destinationLocation
}

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    var polylineArray = [GMSPolyline]()
    
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var weatherList: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var openGoogleMaps: UIButton!
    
    var markerStart: GMSMarker?
    var MarkerEnd: GMSMarker?
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var times: [Date] = []
    var conditions: [String] = []
    var cities: [String] = []
    var highTemps: [Float] = []
    var conditionDescription: [String] = []
    
    var totalDistance = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addButtonsAndLables()
        locationAuthorization()
        setupMap()
    }
    
    /**
      Sets up the Google Maps Map View
    */
    func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151, zoom: 13.0)
        mapView.camera = camera
        mapView.delegate = self
        mapView?.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
    }
    
    /**
     Asks user for location permissions
    */
    func locationAuthorization(){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    /**
     Adds and stylizes weather list button, and time label at bottom. Both are hidden by default
    */
    private func addButtonsAndLables(){
        
        //setup weather list button
        weatherListButtonSetup()
        
        //setup time and distance label
        timeLabelSetup()
        
        //setup Google Maps button
        googleMapsButtonSetup()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //set map to current location
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.mapView?.animate(to: camera)
        
        //set start to current location
        locationStart = location!
        startLocation.text = "Current Location"

        
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
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        mapView.isMyLocationEnabled = true
        mapView.selectedMarker = nil
        return false
    }
    
    /**
     Function to request user location
    */
    func showLocationDisabledPopUp() {
        
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "Your Location is disabled. Enable if you'd like your location to be shown on map",
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
    
    /**
     Controls action when start location button is tapped
    */
    @IBAction func originStartLocation(_ sender: UIButton) {
        
        let autoCompleteControl = GMSAutocompleteViewController()
        autoCompleteControl.delegate = self
        
        //given location
        locationSelected = .startLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteControl, animated: true, completion: nil)
        
    }
    
    /**
     Controls action when destination location button is tapped
     */
    @IBAction func openDestinationLocation(_ sender: UIButton){
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        //given location
        locationSelected = .destinationLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    /*
     Controls when open maps button is clicked
    */
    @IBAction func openGoogleMaps(_ sender: UIButton){
        
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)){
            
            let url = URL(string:
        "comgooglemaps://?saddr=\(String(locationStart.coordinate.latitude)),\(String(locationStart.coordinate.longitude))&daddr=\(String(locationEnd.coordinate.latitude)),\(String(locationEnd.coordinate.longitude))&directionsmode=driving")
            
            UIApplication.shared.open(url!, options: [:])

        } else
        {
            let base = url.GOOGLEMAPS_URL
            let url = URL(string: "\(base)\(Float(locationStart.coordinate.latitude)),\(locationStart.coordinate.longitude))&daddr=\(String(describing: locationEnd.coordinate.latitude)),\(String(describing: locationEnd.coordinate.longitude))")
            
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    /**
    Calls createLine to add polyline to map and also enables the weatherList button and time label at bottom
     */
    func showDirection(){
        
        //show line
        self.createLine(startLocation: locationStart, endLocation: locationEnd) { time in
            
            //enable and show time/distance label, Google Maps button, and Weather List Button
            self.showButtonsAndLabels(time: time)
        }
        
        //clear weather arrays
        cities.removeAll()
        highTemps.removeAll()
        conditions.removeAll()
        conditionDescription.removeAll()
        times.removeAll()
    }

    /**
     Function to create a marker on map
     */
    func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> GMSMarker {
        
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            marker.title = titleMarker
            marker.appearAnimation = .pop
            marker.map = mapView
            return marker
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNavigation"{
            
            //order from start location to finish
            cities.reverse()
            conditions.reverse()
            highTemps.reverse()
            conditionDescription.reverse()
            
            var weatherDataVals: [weatherData.Entry] = []
            var i = cities.count - 1
            var citiesUsed: [String] = []
            while i >= 0 {
                let city = cities[i]
                if !citiesUsed.contains(city){
                    citiesUsed.append(city)
                    let entry = weatherData.Entry(weather: "", city: "", highTemp: 0, condition: "")
                    entry.city = city
                    entry.weather = conditions[i]
                    entry.highTemp = highTemps[i]
                    entry.condition = conditionDescription[i]
                    weatherDataVals.append(entry)
                }
                i = i - 1
            }
            
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! weatherMenu
            targetController.weatherDataArray = weatherDataVals

        }
    }
}

