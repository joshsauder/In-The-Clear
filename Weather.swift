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
        - lat: The latitutde coordinates
        - long: The longitude coordinates
        - timeToLookFor: The date and time that needs to be found
        - completion: After request made, exit with the condition at specified time
    */
    func getWeather(lat: String, long: String, timeToLookFor: Date, completion: @escaping (String) -> ()) {
        
        let urlBase = url.WEATHER_URL
        let urlComplete = urlBase + "lat=\(lat)&lon=\(long)&units=imperial&APPID=0c2beca9233adf894f6acded6d9a946c"
        var condition = ""
        
        //make url request to OpenWeatherAPI
        Alamofire.request(urlComplete, method: .get).responseJSON(completionHandler: {
                (response) in
         
            switch response.result {
            
            case .success:
                let json = JSON(response.data!)
                let weatherList = json["list"].arrayValue
                
                //go through each time increment for a specific location till timeToLookFor is found
                for weather in weatherList
                {
                    //get time
                    let time = weather["dt_txt"].stringValue
                    let temp = weather["main"]["temp_max"].floatValue
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    let dateFromString = dateFormatter.date(from: time)
                    
                    //get condition and weather description
                    let weatherArray = weather["weather"].arrayValue
                    condition = weatherArray[0]["main"].stringValue
                    let description = weatherArray[0]["description"].stringValue
                    
                    //if date time is in range, add it, else move to next time range
                    if(dateFromString!.addingTimeInterval(60.0*60*3) > timeToLookFor || dateFromString!.addingTimeInterval(-60.0*60*3) < timeToLookFor) {
                        
                        //Append time, weather condition and high temp to appropriate arrays
                        self.times.append(dateFromString!)
                        self.conditionDescription.append(description)
                        self.highTemps.append(temp)
                        
                        //return weather condition on completion
                        completion(condition)
                        break;
                    }
                }
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
                    self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 90))
                    group.leave()
                }
                
                group.notify(queue: DispatchQueue.main){
                    //return total time val from json once colorpath and geolocating methods are complete
                    completion(totalTime)
                }
            }
            else {
                //alert user invalid route was input
                let alert = UIAlertController(title: "Invalid Route", message: "Woops! Looks like it's not possible to drive between these two locations.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
        let refDate = Date.timeIntervalSinceReferenceDate
        var date = Date(timeIntervalSinceReferenceDate: refDate)
        var colorSegs: [GMSStyleSpan] = []
        var totalTime = 0
        var i = UInt(0)
        var pathCoordinates = path.coordinate(at: i)
        
        //needed so each api call is called in order
        let group = DispatchGroup()

        if steps.count > 0 {
            
            group.enter()
            
            //move on to next step and remove the previous step in newSteps array
            let step = steps[steps.count - 1]
            var newSteps = steps
            newSteps.remove(at: steps.count - 1)
            
            weatherPerStep(steps: newSteps, path: path) { completion in
                //get completion values from previous recursive call
                colorSegs = completion[0] as! [GMSStyleSpan]
                date = completion[1] as! Date
                totalTime = completion[2] as! Int
                pathCoordinates = completion[3] as! CLLocationCoordinate2D
                i = completion[4] as! UInt
                
                //get the time it takes to traverse a step and add on to totalTime
                let time = step["duration"]["value"].intValue
                date = date.addingTimeInterval(TimeInterval(60 * totalTime))
                totalTime = time + totalTime
                
                //get latitude and logitude
                let lat = step["end_location"]["lat"].stringValue
                let long = step["end_location"]["lng"].stringValue
                var numberSegs = 1
                
                //get weather
                self.getWeather(lat: lat, long: long, timeToLookFor: date) { condition in
                    //append condition to conditions array
                    self.conditions.append(condition)
                    
                    let stepCoordinates = CLLocationCoordinate2D(latitude: step["end_location"]["lat"].doubleValue, longitude: step["end_location"]["lng"].doubleValue)
                        
                    //start from start and go to end... since using end for path
                    while abs(pathCoordinates.latitude - stepCoordinates.latitude) > 0.3 || abs(pathCoordinates.longitude - stepCoordinates.longitude) > 0.3 {
                        //increment the number of segs and the path counter
                        numberSegs = numberSegs + 1
                        i += 1
                        pathCoordinates = path.coordinate(at: i)
                    }
                        
                    //determine which style span to use and append to colorsegs array with the specified number of segments
                    colorSegs.append(self.determineColorSeg(condition: condition, numberSegs: numberSegs))
                    group.leave()
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main){
            completion([colorSegs, date, totalTime, pathCoordinates, i])
        }
    }
    
    /**
     Gets the location name at each directions step
     - parameters:
        - steps: The array containing each direction step
        - completion: Allows each location to be inserted in the city array in order
    */
    func getLocationName(steps: [JSON], completion: @escaping () -> ()) {
        //needed so each API call is in order
        let group = DispatchGroup()
        
        if steps.count > 0 {
            
            group.enter()
            //get the current step and remove the previous step in new step array
            let step = steps[steps.count - 1]
            var newSteps = steps
            newSteps.remove(at: steps.count - 1)
            
            //recursivve call
            getLocationName(steps: newSteps) {
                //get coordinates and include in ARCGIS Reverse Geolocator URL
                let lat = step["end_location"]["lat"].stringValue
                let long = step["end_location"]["lng"].stringValue
                let urlComplete = "\(url.ARCGIS_GEOCODER_URL)\(long),\(lat)"
                
                //make API call to ARCGIS Reverse Geolocation service
                Alamofire.request(urlComplete, method: .get).responseJSON(completionHandler: {
                (response) in
                
                    switch response.result {
                        
                    case .success:
                        //get the city and state and place in cities array
                        let json = JSON(response.data!)
                        let city = json["address"]["City"].stringValue
                        let state = json["address"]["Region"].stringValue
                        let location = "\(city), \(state)"
                        self.cities.append(location)
                        break
                        
                    case .failure(let error):
                        print(error)
                        break
                        
                    }
                    group.leave()
                
                })
            }
        }
        group.notify(queue: DispatchQueue.main){
            completion()
        }
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
        
        if condition == "Rain" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.RAIN, segments: Double(numberSegs))
        } else if condition == "Thunderstorm" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.STORMS, segments: Double(numberSegs))
        } else if condition == "Snow" {
            colorSeg = GMSStyleSpan(style: pathColorSegs.SNOW, segments: Double(numberSegs))
        } else if condition == "Clouds"{
            colorSeg = GMSStyleSpan(style: pathColorSegs.CLOUDS, segments: Double(numberSegs))
        } else {
            colorSeg = GMSStyleSpan(style: pathColorSegs.SUN, segments: Double(numberSegs))
        }
        
        return colorSeg
    }
}
