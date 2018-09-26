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
    
    func getWeather(zipcode: String, country: String){
        var urlBase = "api.openweathermap.org/data/2.5/forecast?"
        let urlComplete = urlBase + "zip=/(zipcode),/(country)"
    
        Alamofire.request(urlComplete, method: .get).validate().responseJSON { response in
            
            let json = JSON(response.data!)
            let largeWeatherList = json["list"]
            let weatherList = largeWeatherList["main"].arrayValue
            
            for weather in weatherList
            {
                //get temperature
                let main = weather["main"]
                self.temps.append(main["temp"].stringValue)
                
                //get condition
                let condition = weather["weather"]
                self.conditions.append(condition["main"].stringValue)
                
                //get time
                let time = weather["dt_txt"].stringValue
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-DD HH:MM:SS"
                let dateFromString = dateFormatter.date(from: time)
                self.times.append(dateFromString!)
            }
        }
    }
    
    func createLine(startLocation: CLLocation, endLocation: CLLocation){
        
        //colors for lines based on condition
        let snow = UIColor.blue
        let rain = UIColor.green
        let storms = UIColor.red
        let sun = UIColor.yellow
        
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
    
    func colorPath() {
        
    }
}
