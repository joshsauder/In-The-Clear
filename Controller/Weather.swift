//
//  Weather.swift
//  InTheClear
//
//  Created by Josh Sauder on 9/19/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import GoogleMaps
import MapKit

extension ViewController {
    
    private struct pathColorSegs {
        static let SNOW = GMSStrokeStyle.solidColor(UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0))
        static let RAIN = GMSStrokeStyle.solidColor(UIColor(red:0.26, green:0.63, blue:0.28, alpha:1.0))
        static let STORMS = GMSStrokeStyle.solidColor(UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0))
        static let SUN = GMSStrokeStyle.solidColor(UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0))
        static let CLOUDS = GMSStrokeStyle.solidColor(UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0))
    }
    
    /**
     Creates an alert on error on the users device
     Stops the spinner and moves the camera back to the users start location
     
     - parameters:
        - title: The title of the alert
        - message: The message contained in the alert
 `  */
    internal func alertTool(title: String, message: String){
        self.present(self.showAlert(title: title, message: message), animated: true)
        
        //animate back to start location
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationStart.coordinate.latitude), longitude: (self.locationStart.coordinate.longitude), zoom: 11.0)
        self.mapView.animate(to: camera)
        
        //need to stop spinner since completion will not be used
        self.stopSpinner(spinner: spinner)
        spinner = nil
        
        //re-enable location buttons
        self.startButton.isEnabled = true
        self.destinationButton.isEnabled = true
    }
    
    /**
     Creates the parameters needed for both API requests
     
     - parameters:
        - steps: The directions JSON array
        - date: Planned departure date
     - returns: Two sets of parameters for the two AWS Lambda functions
    */
    internal func createParamters(steps: [JSON], date: Date) -> (Parameters, Parameters){
        
        //get the time for the current weather step
        let refDate = date.timeIntervalSince1970
        let timeInterval = TimeInterval(refDate)
        var date = Date(timeIntervalSince1970: timeInterval)
        
        var weatherArray: [[String: Any]] = []
        var geolocationArray: [[String: Any]] = []
        
        for step in steps {
            var dictionaryItem: [String: Any] = [:]
            
            //add latitude and longitude coordinates to dictionary
            dictionaryItem["lat"] = step["end_location"]["lat"].stringValue
            dictionaryItem["long"] = step["end_location"]["lng"].stringValue
        
            geolocationArray.append(dictionaryItem)
            
            //time in seconds
            let stepTime = step["duration"]["value"].intValue
            date = date.addingTimeInterval(TimeInterval(stepTime))
            dictionaryItem["time"] = date.timeIntervalSince1970.rounded()
            
            weatherArray.append(dictionaryItem)
        }
        
        let weatherParameters: Parameters = ["List" : weatherArray]
        let geolocationParamters: Parameters = ["List": geolocationArray]
        return (weatherParameters, geolocationParamters)
        
    }
    
    
    /**
     Creates GMSPath on the Map
     
     - parameters:
        - startLocation: The starting location 
        - endLocation: The destination location
        - completion: Upon calling the service, return the total time and distance strings
    */
    internal func createLine(startLocation: CLLocation, endLocation: CLLocation, time: Date, completion: @escaping (Int, Double) -> ()) {
        
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let pathURL = url.PATH_URL + origin + "&destination=" + destination + "&mode=driving&key=" + Constants.GOOGLE_DIRECTIONS_KEY
        
        self.getDirections(url: pathURL) { routes in
            
            //prevents invalid routes from being inputed
            if routes.count > 0 {
                
                //get the direction steps from the directions array
                let routesVal = routes[0]["legs"].arrayValue
                let stepsEval = routesVal[0]
                let totalTime = stepsEval["duration"]["value"].intValue
                let totalDistance = stepsEval["distance"]["value"].doubleValue
                let steps = stepsEval["steps"].arrayValue
                    
                //take first route and use polyline to draw line
                let route = routes[0]
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                    
                //create path and polyline from encoded path
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 7
                    
                //make sure geolocating is complete when Polyline is colored
                let group = DispatchGroup()
                group.enter()
                group.enter()
                    
                let (weatherParam, geolocationParam) = self.createParamters(steps: steps, date: time)
                    //let geolocating and path coloring run simultaneouly
                self.getLocationName(parameters: geolocationParam){
                    group.leave()
                }
                //color the polyline and on completion show polyline on map
                self.colorPath(line: polyline, steps: steps, path: path!, parameters: weatherParam) {
                    if(self.tripData.conditions.count > 0){
                        polyline.map = self.mapView
                        self.polylineArray.append(polyline)
                        self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 95))
                    }
                    group.leave()
                }
                    
                group.notify(queue: DispatchQueue.main){
                    //return total time value from json once colorpath and geolocating methods are complete
                    completion(totalTime, totalDistance)
                }
            }
            else {
                let title = "Invalid Route"
                let message = "Woops! Looks like it's not possible to drive between these two locations."
                self.showAlertTimePopup(title: title, message: message)
                
                
            }
        }
    }

    
    /**
     Colors the GMSPath by what the weather condition is at each coordinate
     
     - parameters:
        - line: The GMSPolyLine representation of the path
        - steps: Each direction (step) from the JSON returned by the Google Directions API
        - path: The directions path
        - parameters: The API request body
        - completion: After weather services callback, exit function
    */
    private func colorPath(line: GMSPolyline, steps: [JSON], path: GMSPath, parameters: Parameters, completion: @escaping () -> ()) {
        //take each step and get weather at end location
        var colorSegs: [GMSStyleSpan] = []
    
        weatherPerStep(steps: steps, path: path, parameters: parameters){ result in
            //on completion get the colorSegs array and set it equal to the style span of the polyline
            colorSegs =  result
            line.spans = colorSegs
            completion()
        }
        
    }
    
    /**
     Gets the weather at each directions step and colors the GMSPath accordingly
     - parameters:
        - steps: The array containing each directions step
        - path: The GMSPath that will be displayed on the map
        - parameters: The API request body
        - completion: An array containing the color segments for the polyline.
    */
    private func weatherPerStep(steps: [JSON], path: GMSPath, parameters: Parameters, completion: @escaping ([GMSStyleSpan]) -> ()) {
        
        var colorSegs: [GMSStyleSpan] = []

        getWeather(parameters: parameters){ json in
            
            var i = UInt(0)
            for (index, item) in json.enumerated() {
                let condition = item["Condition"] as! String
                //determine number of segs for each step
                let (numSegs, index) = self.determineSegCount(step: steps[index], path: path, index: i)
                i = index
                //append each value to corresponding array
                colorSegs.append(self.determineColorSeg(condition: condition, numberSegs: numSegs))
                if item["Severe"] as! Bool {
                    self.tripData.conditions.append("danger")
                } else{
                    self.tripData.conditions.append(condition)
                }
                self.tripData.conditionDescription.append(item["Description"] as! String)
                let temp = item["Temperature"] as! NSNumber
                self.tripData.highTemps.append(temp.floatValue)
            }
            //return colorsegs on completion
            completion(colorSegs)
        }
    }
    
    /**
     Determines the number of segments on the GMSPolyline each step requires
     - parameters:
        - steps: The single directions step
        - path: The path displayed on the users device
        - index: the coordinate index on the GMSPath
     - returns: The number of segs and the last segment index on the GMSPath
    */
    private func determineSegCount(step: JSON, path: GMSPath, index: UInt) -> (Int, UInt){
        //array will contain path index and number of segs
        var i = index
        //get path index
        var pathCoordinates = path.coordinate(at: i)
        //determine step location
        let stepCoordinates = CLLocationCoordinate2D(latitude: step["end_location"]["lat"].doubleValue, longitude: step["end_location"]["lng"].doubleValue)
        
        //while path is in range of step add segs
        var numberSegs = 1
        //start from start and go to end... since using end for path
        while abs(pathCoordinates.latitude - stepCoordinates.latitude) > 0.3 || abs(pathCoordinates.longitude - stepCoordinates.longitude) > 0.3 {
            //increment the number of segs and the path counter
            numberSegs += 1
            i += 1
            pathCoordinates = path.coordinate(at: i)
        }
        
        return (numberSegs, i)
    }
    
    
    /**
     Determines what color each segment in polyline should be
     
     - parameters:
        - condition: The weather condition for the segment(s)
        - numberSegs: The number of segments that need to be colored
     - returns: The GMSStyleSpan for a specific segment(s)
     
    */
    private func determineColorSeg(condition: String, numberSegs: Int) -> GMSStyleSpan {
        let colorSeg: GMSStyleSpan
        //determine condition and set segment color accordingly
        if condition == "rain" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.RAIN, segments: Double(numberSegs))
        } else if condition == "danger" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.STORMS, segments: Double(numberSegs))
        } else if condition == "snow" || condition == "sleet" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.SNOW, segments: Double(numberSegs))
        } else if condition == "cloudy" || condition == "partly-cloudy-day" || condition == "partly-cloudy-night" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.CLOUDS, segments: Double(numberSegs))
        } else {
            colorSeg = GMSStyleSpan(style: pathColorSegs.SUN, segments: Double(numberSegs))
        }
        
        return colorSeg
    }
}
