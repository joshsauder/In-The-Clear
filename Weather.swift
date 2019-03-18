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

extension ViewController {
    func getWeather(lat: String, long: String, timeToLookFor: Date, completion: @escaping (String) -> ()) {
        let urlBase = "http://api.openweathermap.org/data/2.5/forecast?"
        let urlComplete = urlBase + "lat=\(lat)&lon=\(long)&units=imperial&APPID=0c2beca9233adf894f6acded6d9a946c"
        var condition = ""
        Alamofire.request(urlComplete, method: .get).responseJSON(completionHandler: {
                (response) in
         
            switch response.result {
            
            case .success:
                let json = JSON(response.data!)
                let weatherList = json["list"].arrayValue
                
                self.cities.append(json["city"]["name"].stringValue)
                
                for weather in weatherList
                {
                    //get condition
                        
                    //get time
                    let time = weather["dt_txt"].stringValue
                    self.highTemps.append(weather["main"]["temp_max"].floatValue)
                    self.lowTemps.append(weather["main"]["temp_min"].floatValue)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    let dateFromString = dateFormatter.date(from: time)
                    self.times.append(dateFromString!)
                    let weatherArray = weather["weather"].arrayValue
                    condition = weatherArray[0]["main"].stringValue
                    //print(dateFromString!.addingTimeInterval(60*60*3))
                    if(dateFromString!.addingTimeInterval(60.0*60*3) > timeToLookFor || dateFromString!.addingTimeInterval(-60.0*60*3) < timeToLookFor) {
                        //print (condition)
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
    
    func createLine(startLocation: CLLocation, endLocation: CLLocation, completion: @escaping (String) -> ()) {
        
        //colors for lines based on condition
        
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let pathURL = url.PATH_URL + origin + "&destination=" + destination + "&mode=driving&key=" + "AIzaSyDznbmSUzLQ7dBofWqxHg-N6_jxxFBrxy0"
        
        Alamofire.request(pathURL, method: .get).validate().responseJSON { response in
            
            print(response.request as Any)
            
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)
            
            //begin parsing the response
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            if routes.count > 0 {
                let routesVal = routes[0]["legs"].arrayValue
                let stepsEval = routesVal[0]
                let totalTime = stepsEval["duration"]["text"].stringValue
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
    
    func colorPath(line: GMSPolyline, steps: [JSON], path: GMSPath, completion: @escaping (Int) -> ()) {
        //take each step and get weather at end location
        let refDate = Date.timeIntervalSinceReferenceDate
        var date = Date(timeIntervalSinceReferenceDate: refDate)
        var colorSegs: [GMSStyleSpan] = []

        var distance: [Int] = []
        var totalTime = 0
        
        //initialize stroke styles
        let snow = GMSStrokeStyle.solidColor(UIColor(red:0.43, green:0.39, blue:1.00, alpha:1.0))
        let rain = GMSStrokeStyle.solidColor(UIColor(red:0.35, green:0.93, blue:0.35, alpha:1.0))
        let storms = GMSStrokeStyle.solidColor(UIColor(red:0.89, green:0.11, blue:0.34, alpha:1.0))
        let sun = GMSStrokeStyle.solidColor(UIColor.yellow)
        let clouds = GMSStrokeStyle.solidColor(UIColor(red:0.63, green:0.62, blue:0.62, alpha:1.0))
        
        //Needed for async
        let myGroup = DispatchGroup()
        
        var i = UInt(0)
        var pathCoordinates = path.coordinate(at: i)
        
        for step in steps {
            
            myGroup.enter()
            //get distance
            let time = step["duration"]["value"].intValue
            distance.append(time)
            date = date.addingTimeInterval(TimeInterval(60 * totalTime))
            totalTime = time + totalTime
            //get weather
            let lat = step["end_location"]["lat"].stringValue
            let long = step["end_location"]["lng"].stringValue
            var numberSegs = 1
            
            
            getWeather(lat: lat, long: long, timeToLookFor: date) { condition in
            
                self.conditions.append(condition)
                
                let stepCoordinates = CLLocationCoordinate2D(latitude: step["end_location"]["lat"].doubleValue, longitude: step["end_location"]["lng"].doubleValue)
                
                //add segments between each path coordinate
                while pathCoordinates.latitude.rounded() == stepCoordinates.latitude.rounded() && pathCoordinates.longitude.rounded() == stepCoordinates.longitude.rounded() {
                    
                    numberSegs = numberSegs + 1
                    i = i + 1
                    pathCoordinates = path.coordinate(at: i)
                }
                
                //determine which style span to use
                if condition == "Rain" {
                    colorSegs.append(GMSStyleSpan(style: rain, segments: Double(numberSegs)))
                } else if condition == "Thunderstorm" {
                    colorSegs.append(GMSStyleSpan(style: storms, segments: Double(numberSegs)))
                } else if condition == "Snow" {
                    colorSegs.append(GMSStyleSpan(style: snow, segments: Double(numberSegs)))
                } else if condition == "Clouds"{
                    colorSegs.append(GMSStyleSpan(style: clouds, segments: Double(numberSegs)))
                } else {
                    colorSegs.append(GMSStyleSpan(style: sun, segments: Double(numberSegs)))
                }
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: .main) {
            line.spans = colorSegs
            completion(totalTime)
        }
        
        //take step time divided by total time
       // line.spans = colorSegs
        //color path based on fraction
    }
}
