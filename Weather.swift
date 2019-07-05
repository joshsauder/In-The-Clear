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
    
    struct pathColorSegs {
        static let SNOW = GMSStrokeStyle.solidColor(UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0))
        static let RAIN = GMSStrokeStyle.solidColor(UIColor(red:0.26, green:0.63, blue:0.28, alpha:1.0))
        static let STORMS = GMSStrokeStyle.solidColor(UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0))
        static let SUN = GMSStrokeStyle.solidColor(UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0))
        static let CLOUDS = GMSStrokeStyle.solidColor(UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0))
    }
    
    /**
     Calls the OpenWeather API service and populates the weather array
     
     - parameters:
     - parameters: The API request body
        - completion: After request made, exit with the condition at specified time
    */
    func getWeather(parameters: Parameters, completion: @escaping ([[String: Any]]) -> ()) {
        
        let AWSURL = url.AWS_WEATHER_URL

        //make url request to AWS Weather Fuction
        Alamofire.request(AWSURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {
                (response) in
         
            switch response.result {
            
            case .success(let json):
                print(json)
                completion(json as! [[String:Any]])
                break;
                
            case .failure(let error):
                print(error)
                break;
            }
        })
    }
    
    /**
     Creates GMSPath on the Map
     
     - parameters:
        - startLocation: The starting location
        - endLocation: The destination location
        - completion: Upon calling the service, return the total time string
    */
    func createLine(startLocation: CLLocation, endLocation: CLLocation, completion: @escaping (String) -> ()) {
        
        //colors for lines based on condition
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let pathURL = url.PATH_URL + origin + "&destination=" + destination + "&mode=driving&key=" + "AIzaSyDznbmSUzLQ7dBofWqxHg-N6_jxxFBrxy0"
        
        Alamofire.request(pathURL, method: .get).validate().responseJSON { response in

            //begin parsing the response
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            
            //prevents invalid routes from being inputed
            if routes.count > 0 {
                
                //get the direction steps from the directions array
                let routesVal = routes[0]["legs"].arrayValue
                let stepsEval = routesVal[0]
                let totalTime = stepsEval["duration"]["text"].stringValue
                self.totalDistance = stepsEval["distance"]["text"].stringValue
                let steps = stepsEval["steps"].arrayValue
                
                //prevent routes that are too long too handle
                if stepsEval["duration"]["value"].intValue < 147600 {
                //remove any existing polylines
                    self.polylineArray.forEach { $0.map = nil }

                    
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
                    
                    //let geolocating and path coloring run simultaneouly
                    self.getLocationName(steps: steps){
                        group.leave()
                    }
                    //color the polyline and on completion show polyline on map
                    self.colorPath(line: polyline, steps: steps, path: path!) {
                        polyline.map = self.mapView
                        self.polylineArray.append(polyline)
                        self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 80))
                        group.leave()
                    }
                    
                    group.notify(queue: DispatchQueue.main){
                        //return total time value from json once colorpath and geolocating methods are complete
                        completion(totalTime)
                    }
                }
                else{
                    //alert user route is currently too long
                    self.showAlert(title: "Invalid Route", message: "Sorry! At this time, In The Clear does not support routes longer than 51 hours.")
                    
                    //animate back to start location
                    let camera = GMSCameraPosition.camera(withLatitude: (self.locationStart.coordinate.latitude), longitude: (self.locationStart.coordinate.longitude), zoom: 11.0)
                    self.mapView.animate(to: camera)
                    
                    //need to stop spinner since completion will not be used
                    self.stopSpinner()
                    //re-enable location buttons
                    self.startButton.isEnabled = true
                    self.destinationButton.isEnabled = true
                }
            }
            else {
                //alert user invalid route was input
                self.showAlert(title: "Invalid Route", message: "Woops! Looks like it's not possible to drive between these two locations.")
                
                //animate back to start location
                let camera = GMSCameraPosition.camera(withLatitude: (self.locationStart.coordinate.latitude), longitude: (self.locationStart.coordinate.longitude), zoom: 11.0)
                self.mapView.animate(to: camera)
                
                //need to stop spinner since completion will not be used
                self.stopSpinner()
                //re-enable location buttons
                self.startButton.isEnabled = true
                self.destinationButton.isEnabled = true
            }
        }
    }
    
    /**
     Colors the GMSPath by what the weather condition is at each coordinate
     
     - parameters:
        - line: The GMSPolyLine representation of the path
        - steps: Each direction (step) from the JSON returned by the Google Directions API
        - path: The directions path
        - completion: After weather services callback, exit function
    */
    func colorPath(line: GMSPolyline, steps: [JSON], path: GMSPath, completion: @escaping () -> ()) {
        //take each step and get weather at end location
        var colorSegs: [GMSStyleSpan] = []
    
        weatherPerStep(steps: steps, path: path){ result in
            //on completion get the colorSegs array and set it equal to the style span of the polyline
            colorSegs =  result[0] as! [GMSStyleSpan]
            line.spans = colorSegs
            completion()
        }
        
    }
    
    /**
     Gets the weather at each directions step and colors the GMS path accordingly
     - parameters:
        - steps: The array containing each directions step
        - path: The GMSPath that will be displayed on the map
        - completion: An array containing the color segments for the polyline, the date that you will arrive to a certain step, the total amount of time, the current path coordinates, and a counter to keep track of where you are in the path.
    */
    func weatherPerStep(steps: [JSON], path: GMSPath, completion: @escaping ([Any]) -> ()) {
        //any will contain colorseg, date, totalTime, pathCoordinates
        //get the time for the current weather step
        let refDate = Date().timeIntervalSince1970
        let timeInterval = TimeInterval(refDate)
        var date = Date(timeIntervalSince1970: timeInterval)
        
        var colorSegs: [GMSStyleSpan] = []
        var totalTime = 0
        let i = UInt(0)
        let pathCoordinates = path.coordinate(at: i)
        
        var listarray: [[String: Any]] = []
        
        for step in steps {
            var dictionaryItem: [String: Any] = [:]
            
            //time in seconds
            let stepTime = step["duration"]["value"].intValue
            totalTime += stepTime
            date = date.addingTimeInterval(TimeInterval(stepTime))
            dictionaryItem["time"] = date.timeIntervalSince1970.rounded()
            
            //add latitude and longitude in WGS84 format
            dictionaryItem["long"] = step["end_location"]["lat"].stringValue
            dictionaryItem["lat"] = step["end_location"]["lng"].stringValue
            
            listarray.append(dictionaryItem)
        }
        
        let weatherJSON: Parameters = ["List" : listarray]

        getWeather(parameters: weatherJSON){ json in
            var i = UInt(0)
            for (index, item) in json.enumerated() {
                let condition = item["Condition"] as! String
                let (numSegs, index) = self.determineSegCount(step: steps[index], path: path, index: i)
                i = index
                colorSegs.append(self.determineColorSeg(condition: condition, numberSegs: numSegs))
                self.conditions.append(condition)
                self.conditionDescription.append(item["Description"] as! String)
                let temp = item["Temperature"] as! NSNumber
                self.highTemps.append(temp.floatValue)
            }
            completion([colorSegs, date, totalTime, pathCoordinates, i])
        }
    }
    
    func determineSegCount(step: JSON, path: GMSPath, index: UInt) -> (Int, UInt){
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
     Gets the location name at each directions step
     - parameters:
        - steps: The array containing each direction step
        - completion: Allows each location to be inserted in the city array in order
    */
    func getLocationName(steps: [JSON], completion: @escaping () -> ()) {

            //create array of dictionaries for each individual coordinate
            var listarray: [[String: Any]] = []
            for step in steps {
                var dictionaryItem: [String: Any] = [:]
                //need to flip in order to comply with WGS84 coordinates format
                dictionaryItem["long"] = step["end_location"]["lat"].stringValue
                dictionaryItem["lat"] = step["end_location"]["lng"].stringValue
                listarray.append(dictionaryItem)
            }
            
            //create dictionary of coordinates with key being list
            let coordinatesJSON: Parameters = ["list" : listarray]
            let urlComplete = url.AWS_REVERSE_GEOLOCATION_URL
                
            //make API call to AWS Lambda Reverse Geolocating function
            Alamofire.request(urlComplete, method: .post, parameters: coordinatesJSON, encoding: JSONEncoding.default).responseJSON(completionHandler: {
            (response) in
                
                switch response.result {
                        
                case .success(let JSON):
                    print(JSON)
                    
                    //An array is returned so cast the response as an array
                    let jsonData = JSON as? [String]
                    //append response array to cities array
                    self.cities.append(contentsOf: jsonData!)
                        
                case .failure(let error):
                    print(error)
                    break
                        
                }
                completion()
            })
    }
    
    /**
     Determines what color each segment in polyline should be
     
     - parameters:
     - condition: The weather condition for the segment(s)
     - numberSegs: The number of segments that need to be colored
     - returns: The GMSStyleSpan for a specific segment(s)
     
    */
    func determineColorSeg(condition: String, numberSegs: Int) -> GMSStyleSpan {
        let colorSeg: GMSStyleSpan
        
        if condition == "rain" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.RAIN, segments: Double(numberSegs))
        } else if condition == "Thunderstorm" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.STORMS, segments: Double(numberSegs))
        } else if condition == "snow" || condition == "sleet" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.SNOW, segments: Double(numberSegs))
        } else if condition == "clouds" || condition == "partly-cloudy-day" || condition == "partly-cloudy-night" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.CLOUDS, segments: Double(numberSegs))
        } else {
            colorSeg = GMSStyleSpan(style: pathColorSegs.SUN, segments: Double(numberSegs))
        }
        
        return colorSeg
    }
}
