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
    
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var times: [Date] = []
    var conditions: [String] = []
    var cities: [String] = []
    var highTemps: [Float] = []
    var lowTemps: [Float] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addGlyph()
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
    
    func addGlyph(){
        
        //set up weatherButton
        weatherList.layer.cornerRadius = 5
        weatherList.clipsToBounds = true
        weatherList.setTitle("Expanded City List" , for: .normal)
        weatherList.setTitleColor(UIColor.black, for: .normal)
        weatherList.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        weatherList.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        //add shadow to button
        weatherList.layer.shadowColor = UIColor.black.cgColor
        weatherList.layer.masksToBounds = false
        weatherList.layer.shadowOffset = CGSize(width: 5, height: 5)
        weatherList.layer.shadowRadius = 5
        weatherList.layer.shadowOpacity = 1.0
        
        //disable button at start
        weatherList.isEnabled = false
        weatherList.alpha = 0.5
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
    
    //function that calls createLine to create directions line on map
    func showDirection(){
        //show line
        self.createLine(startLocation: locationStart, endLocation: locationEnd)
        //enable button
        weatherList.isEnabled = true
        weatherList.alpha = 1
    }

    
    // function to create a marker on map
    func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.map = mapView
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNavigation"{
            var weatherDataVals: [weatherData.Entry] = []
            while conditions.count > 0 {
                let city = cities.remove(at: 0)
                if !cities.contains(city){
                    let entry = weatherData.Entry(weather: "", city: "", highTemp: 0, lowTemp: 0)
                    entry.city = city
                    entry.weather = conditions.remove(at: 0)
                    entry.highTemp = highTemps.remove(at: 0)
                    entry.lowTemp = lowTemps.remove(at: 0)
                    weatherDataVals.append(entry)
                }else{
                    conditions.remove(at: 0)
                    highTemps.remove(at: 0)
                    lowTemps.remove(at: 0)
                }
            }
            
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! weatherMenu
            targetController.weatherDataArray = weatherDataVals

        }
    }
    
    
}

