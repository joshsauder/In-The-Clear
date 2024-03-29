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
import Foundation
import StoreKit

enum Location {
    case startLocation
    case destinationLocation
}

protocol TripDetailsDetegate: class {
    func intializeLocationData() -> tripDetailsModal
    func recieveLocationData(tripDetials: tripDetailsModal)
}


class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, TripDetailsDetegate {
    
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    let realmManager = RealmManager()
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    @IBOutlet weak var weatherList: UIButton!
    
    @IBOutlet weak var timeAndDistanceView: UIView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var drivingTimeLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    
    @IBOutlet weak var myLocationButton: UIButton!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var setTime: UIButton!
    @IBOutlet weak var mapKey: UIImageView!
    
    @IBOutlet weak var openMapsBottomContraints: NSLayoutConstraint!
    @IBOutlet weak var BottomLabelConstraint: NSLayoutConstraint!
    
    var spinner: UIView?
    var tripData = tripDataModal()
    var userTripDetails = tripDetailsModal()
    var polylineArray = [GMSPolyline]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add buttons and labels to UIView
        addButtonsAndLables()
        //set up mapkey
        mapkeySetup()
        //make sure user has enabled current location
        locationAuthorization()
        //set up GMSMap
        setupMap()
        //Request Review
        requestReviewIfAppropriate()
    }
    
    /**
      Sets up the Google Maps Map View
    */
    private func setupMap(){
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151, zoom: 11.0)
        mapView.camera = camera
        mapView.delegate = self
        mapView?.isMyLocationEnabled = true
        //myLocationButton.isHidden = false
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        
        //show location button, if enabled
        showLocationButton()
    }
    
    /**
     Asks user for location permissions
    */
    internal func locationAuthorization(){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //show location button, if enabled
        showLocationButton()

    }
    
    /**
     Adds and stylizes weather list button, and time label at bottom. Both are hidden by default
    */
    private func addButtonsAndLables(){
        
        //setup weather list button
        weatherListButtonSetup()
        //setup time and distance label
        timeLabelSetup()
        //setup Google Maps and Set Time button
        mapButtonsSetup()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //set map to current location
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 11.0)
        self.mapView?.animate(to: camera)

        
        //set start to current location
        locationStart = location!
        startLocation.text = "Current Location"
        
        //if location services are not enabled google maps and set time buttons down
        //else show location button
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                openMapsBottomContraints.constant = 10
            case .authorizedAlways, .authorizedWhenInUse:
                myLocationButton.isHidden = false
                openMapsBottomContraints.constant = 77
            }
        } else {
            openMapsBottomContraints.constant = 10
        }

        
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
     Function to request user enable location services in settings
    */
    internal func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "Your Location is disabled. Enable if you'd like your location to be shown on map",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
        Initializes the initail trip details modal
     */
    func intializeLocationData() -> tripDetailsModal {
        let tripDetails = userTripDetails
        
        if userTripDetails.cityStops.count == 0 {
            //append first and last city
            tripDetails.cityStops.append(contentsOf: [startLocation.text!, destinationLocation.text!])
            //need two dates in the case first or last city are reordered
            tripDetails.startTimes.append(contentsOf: [Date(), Date()])
            //add start and end locations
            tripDetails.cityLocations.append(contentsOf: [locationStart, locationEnd])
        }
        
        return tripDetails
    }
    
    /**
        Retrieves the location data from the user inputted trip details
        - parameters:
            - tripDetails: the user inputted trip details
     */
    func recieveLocationData(tripDetials: tripDetailsModal) {
        userTripDetails = tripDetials
        processTripData()
    }
    
    /**
     Function that processes the trip details (calls show directions).
     */
    private func processTripData(){
        showDirection()
    }
    
    /**
     Moves map camera to current location when location button is clicked
     - parameters:
        - sender: the UIButton being interacted with
    */
    @IBAction func moveToCurrentLocation(_ sender: UIButton) {
        //Since location is not always enabled
        guard let lat = self.mapView.myLocation?.coordinate.latitude,
              let long = self.mapView.myLocation?.coordinate.longitude
        else {return}
            
        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: long , zoom: 11.0)
        self.mapView.animate(to: camera)
        
    }
    
    /**
     Controls action when start location button is tapped
     - parameters:
        - sender: the UIButton being interacted with
    */
    @IBAction func originStartLocation(_ sender: UIButton) {
        //open GMSAutocomplete controllerand present
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        //set table dark
        autoCompleteController.setCellDark()
                
        //given location
        locationSelected = .startLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    /**
     Controls action when destination location button is tapped
     - parameters:
        - sender: the UIButton being interacted with
     */
    @IBAction func openDestinationLocation(_ sender: UIButton){
        //open GMSAutocomplete controllerand present
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        //set table dark
        autoCompleteController.setCellDark()

        
        //given location
        locationSelected = .destinationLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    /**
     Controls when open maps button is clicked
     - parameters:
        - sender: the UIButton being interacted with
    */
    @IBAction func showMapsActionSheet(_ sender: UIButton){
        let alert = UIAlertController(title: "Select a Map Option", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Open Apple Maps", style: .default, handler: { (_) in
            self.openAppleMaps()
        }))
        alert.addAction(UIAlertAction(title: "Open Google Maps", style: .default, handler: { (_) in
            self.openGoogleMaps()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))

        self.present(alert, animated: true)

    }
    
    /**
     Opens Apple Maps App with directions
    */
    internal func openAppleMaps() {
        let startPoint = "\(Float(locationStart.coordinate.latitude)),\(Float(locationStart.coordinate.longitude))"
        let endPoint = "\(Float(locationEnd.coordinate.latitude)),\(Float( locationEnd.coordinate.longitude))"
        guard let url = URL(string:"maps://?saddr=\(startPoint)&daddr=\(endPoint)&dirfgl=c") else { return }
        
        UIApplication.shared.open(url)
    }
    
    /**
     Opens Google Maps App (or website if app is not installed) with directions
    */
    internal func openGoogleMaps(){
        //set up waypoints
        var waypoints = "&waypoints="
        var appWaypoints=""
        
        var i = 1
        while i < userTripDetails.cityStops.count - 1 {
            waypoints.append(contentsOf: userTripDetails.cityStops[i])
            appWaypoints.append(contentsOf: userTripDetails.cityStops[i] + "/")
            if i != 1 {
                waypoints.append(contentsOf: "%7C")
            }
            i += 1
        }
        
        if UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL){
            guard let url = NSURL(string: "comgooglemapsurl://www.google.com/maps/dir/\(Float(locationStart.coordinate.latitude)),\(Float(locationStart.coordinate.longitude))/\(appWaypoints)\(Float(locationEnd.coordinate.latitude)),\(Float( locationEnd.coordinate.longitude))") else { return; }
            
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            
        } else {
            //call google maps to open up directions
            let base = url.GOOGLEMAPS_URL
            guard let url = URL(string: "\(base)\(Float(locationStart.coordinate.latitude)),\(Float(locationStart.coordinate.longitude))&daddr=\(Float(locationEnd.coordinate.latitude)),\(Float( locationEnd.coordinate.longitude))&travelMode=driving\(waypoints)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)!) else { return; }
                
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    /**
     Shows the time popup when the start and end locations are given
     - parameters:
        - sender: the UIButton being interacted with
    */
    internal func showTimePopupInitially(){
        userTripDetails = tripDetailsModal()
        let tripDetailVC = storyboard?.instantiateViewController(withIdentifier: "customizeTripDetails") as! CustomizeTripDetails
        tripDetailVC.modalPresentationStyle = .overCurrentContext
        tripDetailVC.delegate = self
        self.present(tripDetailVC, animated: true, completion: nil)
    }
    
    /**
     Shows the time popup when the UIButton is clicked
     - parameters:
        - sender: the UIButton being interacted with
    */
    @IBAction func showTimePopup(_ sender: UIButton) {
        let tripDetailVC = storyboard?.instantiateViewController(withIdentifier: "customizeTripDetails") as! CustomizeTripDetails
        tripDetailVC.modalPresentationStyle = .overCurrentContext
        tripDetailVC.delegate = self
        self.present(tripDetailVC, animated: true, completion: nil)
    }
    
    /**
    Calls createLine to add polyline to map and also enables the weatherList button and time label at bottom
     */
    private func showDirection(){
        let user = realmManager.getUser()
        
        let different = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.hour], from: Date(), to: userTripDetails.endTime)
        
        //dark sky only supports dates up to 7 days out
        if different.day! > 6 {
            showAlertTimePopup(title: "Trip Too Long", message: "Looks like you're trip is too long. Try shortening your tip up a bit.")
            
        } else if !user.paid && different.hour! > 5 {
            showAlertTimePopup(title: "Trip Too Long", message: "Looks like you're not a premium user. Upgrade to Premium to use a trip longer than 5 hours.")
        } else {
        
            disableInputButtons()
            
            //clear weather arrays
            tripData.removeAll()
            mapView.clear()
            //remove any existing polylines
            self.polylineArray.forEach { $0.map = nil }
            spinner = showSpinner(view: view)
            
            //show line
            self.processStops(index: self.userTripDetails.cityLocations.count - 1) { time, distance in
                
                var timeString = ""
                if time < 3600 {
                    timeString = "\(time % 3600 / 60)min"
                } else {
                    timeString = "\(time / 3600)hr \(time % 3600 / 60)min"
                }
                let finalDistance = round(distance * 0.00062137)
                
                self.tripData.reverse()
                
                var totalTimeString = ""
                if self.userTripDetails.cityStops.count != 2 {
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .brief
                    formatter.allowedUnits = [.hour, .minute]
                    //need to use last start time plus offset
                    totalTimeString = formatter.string(from: self.userTripDetails.startTimes[0], to: self.userTripDetails.endTime)!
                } else {
                    totalTimeString = timeString
                }
                //enable and show time/distance label, Google Maps button, and Weather List Button
                self.showButtonsAndLabels(drivingTime: timeString, totalTime: totalTimeString, distance: finalDistance)
                //re-enable location buttons
                self.startButton.isEnabled = true
                self.destinationButton.isEnabled = true
                
                for (index, location) in self.userTripDetails.cityLocations.enumerated() {
                    
                    self.createMarker(titleMarker: self.userTripDetails.cityStops[index], latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
                
                self.stopSpinner(spinner: self.spinner)
                self.spinner = nil
                
                //set trip data stops
                self.tripData.stops = self.userTripDetails.cityStops
                self.tripData.stops[0] = self.tripData.cities[self.tripData.cities.count-1]
                
                self.postTrip(tripData: self.tripData, distance: Int(distance), duration: time, locations: self.userTripDetails.cityLocations)
                
            }
        }
    }
    
    /**
    Process data from each user selected stop
     
     - parameters:
        - index: The index of the stop being processed
        - completion: The total time and total distance returned on completion
     */
    private func processStops(index: Int, completion: @escaping (Int, Double) -> ()){
        
        let group = DispatchGroup()
        var finalTime = 0
        var finalDistance = Double(0)
        
        if (index > 0) {
            group.enter()
            processStops(index: index - 1) { time, distance in
                finalTime = time
                finalDistance = distance
                self.createLine(startLocation: self.userTripDetails.cityLocations[index-1], endLocation: self.userTripDetails.cityLocations[index], time: self.userTripDetails.startTimes[index]){ time, distance in
                    finalTime += time
                    finalDistance += distance
                    group.leave()
                }
                
            }
        }
        group.notify(queue: DispatchQueue.main){
            
            completion(finalTime, finalDistance)
        }
    }

    /**
     Function to create a marker on map
     - parameters:
        - titleMarker: The markers title that pops up when the marker is tapped
        - latitude: The markers latitude coordinate
        - longitude: The markers longitude
     */
    private func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            //set up marker using given title and place the marker on the map
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            marker.title = titleMarker
            marker.appearAnimation = .pop
            marker.map = mapView
    }

    /**
     Function called that sends the weather data values to the weather table
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNavigation"{
            
            //set up weatherDataVals array
            var weatherDataVals: [weatherData.Entry] = []
            //create counter equal to the number of cities in city array
            var i = tripData.cities.count - 1
            var citiesUsed: [String] = []
            while i >= 0 {
                //Prevents cities from being listed in weather table multiple times
                let city = tripData.cities[i]
                if !citiesUsed.contains(city){
                    citiesUsed.append(city)
                    //create weatherData entry
                    let entry = weatherData.Entry(weather: "", city: "", highTemp: 0, condition: "")
                    entry.city = city
                    
                    //get weathers, temperature, and condition
                    entry.weather = tripData.conditions[i]
                    entry.highTemp = tripData.highTemps[i]
                    entry.condition = tripData.conditionDescription[i]
                    weatherDataVals.append(entry)
                }
                //decrement counter
                i = i - 1
            }
            //set weatherData array equal to weatherDataVals array in WeatherMenu
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! weatherMenu
            targetController.weatherDataArray = weatherDataVals

        }
    }
    
    /**
     Requests a review when the user has logged in 3 times
     */
    private func requestReviewIfAppropriate() {
        let defaultKey = "userReview"
        var count = UserDefaults.standard.integer(forKey: defaultKey)
        count += 1
        UserDefaults.standard.set(count, forKey: defaultKey)
        
        guard count == 3 else {
            return
        }
        
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                SKStoreReviewController.requestReview()
            }
        }
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
