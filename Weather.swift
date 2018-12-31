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
        let url = URL(string: urlComplete)!
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
                    print(dateFromString!.addingTimeInterval(60*60*3))
                    if(dateFromString!.addingTimeInterval(60.0*60*3) > timeToLookFor || dateFromString!.addingTimeInterval(-60.0*60*3) < timeToLookFor) {
                        print (condition)
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
    
    func createLine(startLocation: CLLocation, endLocation: CLLocation){
        
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
            
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            let routesVal = routes[0]["legs"].arrayValue
            let stepsEval = routesVal[0]
            let steps = stepsEval["steps"].arrayValue
            
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 7
                self.colorPath(line: polyline, steps: steps)
                polyline.map = self.mapView
                self.mapView.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: polyline.path!), withPadding: 50))
            }
            
        }
    }
    
    func colorPath(line: GMSPolyline, steps: [JSON]) {
        //take each step and get weather at end location
        let refDate = Date.timeIntervalSinceReferenceDate
        var date = Date(timeIntervalSinceReferenceDate: refDate)
        var colorSegs: [GMSStyleSpan] = []

        var distance: [Int] = []
        var totalTime = 0
        
        let snow = GMSStrokeStyle.solidColor(UIColor.blue)
        let rain = GMSStrokeStyle.solidColor(UIColor.green)
        let storms = GMSStrokeStyle.solidColor(UIColor.red)
        let sun = GMSStrokeStyle.solidColor(UIColor.yellow)
        
        for step in steps {
            //get distance
            let time = step["duration"]["value"].intValue
            distance.append(time)
            date = date.addingTimeInterval(TimeInterval(60 * totalTime))
            totalTime = time + totalTime
            //get weather
            let lat = step["end_location"]["lat"].stringValue
            let long = step["end_location"]["lng"].stringValue
            
            getWeather(lat: lat, long: long, timeToLookFor: date) { condition in
            
                self.conditions.append(condition)
                
            if condition == "Rain" {
                colorSegs.append(GMSStyleSpan(style: rain))
            } else if condition == "Thunderstorm" {
                colorSegs.append(GMSStyleSpan(style: storms))
            } else if condition == "Snow" {
                colorSegs.append(GMSStyleSpan(style: snow))
            } else {
                colorSegs.append(GMSStyleSpan(style: sun))
            }
            line.spans = colorSegs
            }
        }
        //take step time divided by total time
       // line.spans = colorSegs
        //color path based on fraction
    }
}
