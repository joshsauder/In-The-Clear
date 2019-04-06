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
     Calls the OpenWeather API service and populates the weather arrays and city arrays
     
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
        Alamofire.request(urlComplete, method: .get).responseJSON(completionHandler: {
                (response) in
         
            switch response.result {
            
            case .success:
                let json = JSON(response.data!)
                let weatherList = json["list"].arrayValue
                let location = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
                
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
                    (placemarks, errors) in
                    if let error = errors as? CLError {
                        print("CLError:", error)
                    }
                    else if let placemark = placemarks?.first {
                        self.cities.append("\(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")")
                    }

                })
                //self.cities.append(json["city"]["name"].stringValue)
                
                for weather in weatherList
                {
                    //get condition
                        
                    //get time
                    let time = weather["dt_txt"].stringValue
                    let temp = weather["main"]["temp_max"].floatValue
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    let dateFromString = dateFormatter.date(from: time)
                    let weatherArray = weather["weather"].arrayValue
                    condition = weatherArray[0]["main"].stringValue
                    let description = weatherArray[0]["description"].stringValue
                    
                    //print(dateFromString!.addingTimeInterval(60*60*3))
                    if(dateFromString!.addingTimeInterval(60.0*60*3) > timeToLookFor || dateFromString!.addingTimeInterval(-60.0*60*3) < timeToLookFor) {
                        //print (condition)
                        self.times.append(dateFromString!)
                        self.conditionDescription.append(description)
                        self.highTemps.append(temp)
                        print(condition)
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
            if routes.count > 0 {
                let routesVal = routes[0]["legs"].arrayValue
                let stepsEval = routesVal[0]
                let totalTime = stepsEval["duration"]["text"].stringValue
                self.totalDistance = stepsEval["distance"]["text"].stringValue
                let steps = stepsEval["steps"].arrayValue
                self.polylineArray.forEach { $0.map = nil }
                
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    
                    //create path and polyline from encoded path
                    let path = GMSPath.init(fromEncodedPath: points!)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 7
                    self.polylineArray.append(polyline)
                    self.colorPath(line: polyline, steps: steps, path: path!) { time in
                        polyline.map = self.mapView
                        self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 50))
                        //return total time val from json once colorpath method completes
                        completion(totalTime)
                    }
                }
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
    func colorPath(line: GMSPolyline, steps: [JSON], path: GMSPath, completion: @escaping (Int) -> ()) {
        //take each step and get weather at end location
        var colorSegs: [GMSStyleSpan] = []

        var totalTime = 0
        
        //initialize stroke styles
        
        //Needed for async
        
        
        weatherPerStep(steps: steps, path: path){ result in
            
            colorSegs =  result[0] as! [GMSStyleSpan]
            colorSegs.reverse()
            
            line.spans = colorSegs
            totalTime = result[2] as! Int
            completion(totalTime)
        }
        
    }
    
    func weatherPerStep(steps: [JSON], path: GMSPath, completion: @escaping ([Any]) -> ()) {
        //any will contain colorseg, date, totalTime, pathCoordinates
        let refDate = Date.timeIntervalSinceReferenceDate
        var date = Date(timeIntervalSinceReferenceDate: refDate)
        var colorSegs: [GMSStyleSpan] = []
        var totalTime = 0
        var i = UInt(path.count()-1)
        var pathCoordinates = path.coordinate(at: i)

        let group = DispatchGroup()

        if steps.count > 1 {
            
            group.enter()
            
            let step = steps[0]
            var newSteps = steps
            newSteps.remove(at: 0)
            
            weatherPerStep(steps: newSteps, path: path) { completion in
                
                colorSegs = completion[0] as! [GMSStyleSpan]
                date = completion[1] as! Date
                totalTime = completion[2] as! Int
                pathCoordinates = completion[3] as! CLLocationCoordinate2D
                i = completion[4] as! UInt
            
                let time = step["duration"]["value"].intValue
                date = date.addingTimeInterval(TimeInterval(60 * totalTime))
                totalTime = time + totalTime
                //get weather
                let lat = step["end_location"]["lat"].stringValue
                let long = step["end_location"]["lng"].stringValue
                var numberSegs = 0
                
            
                self.getWeather(lat: lat, long: long, timeToLookFor: date) { condition in
                    
                    self.conditions.append(condition)
                    
                    let stepCoordinates = CLLocationCoordinate2D(latitude: step["end_location"]["lat"].doubleValue, longitude: step["end_location"]["lng"].doubleValue)
                    
                    //add segments between each path coordinate
                    while pathCoordinates.latitude.rounded() != stepCoordinates.latitude.rounded() && pathCoordinates.longitude.rounded() != stepCoordinates.longitude.rounded() {
                        
                        numberSegs = numberSegs + 1
                        i -= 1
                        pathCoordinates = path.coordinate(at: i)
                    }
                    
                    print("\(lat) \(long) \(pathCoordinates.latitude) \(pathCoordinates.longitude) \(String(numberSegs)) \(String(i))")
                    
                    //determine which style span to use
                    if condition == "Rain" {
                        colorSegs.append(GMSStyleSpan(style: pathColorSegs.RAIN, segments: Double(numberSegs)))
                    } else if condition == "Thunderstorm" {
                        colorSegs.append(GMSStyleSpan(style: pathColorSegs.STORMS, segments: Double(numberSegs)))
                    } else if condition == "Snow" {
                        colorSegs.append(GMSStyleSpan(style: pathColorSegs.SNOW, segments: Double(numberSegs)))
                    } else if condition == "Clouds"{
                        colorSegs.append(GMSStyleSpan(style: pathColorSegs.CLOUDS, segments: Double(numberSegs)))
                    } else {
                        colorSegs.append(GMSStyleSpan(style: pathColorSegs.SUN, segments: Double(numberSegs)))
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: DispatchQueue.main){
            completion([colorSegs, date, totalTime, pathCoordinates, i])
        }
    }
}
