//
//  APIRequests.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/9/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension ViewController {
    
    /**
     Calls the AWS Lambda Weather API service and populates the weather array
     
     - parameters:
     - parameters: The API request body
     - completion: After request made, exit with the condition at specified time
     */
    func getWeather(steps: [JSON], completion: @escaping ([[String: Any]]) -> ()) {
        
        //get the time for the current weather step
        let refDate = Date().timeIntervalSince1970
        let timeInterval = TimeInterval(refDate)
        var date = Date(timeIntervalSince1970: timeInterval)
        
        var listarray: [[String: Any]] = []
        
        for step in steps {
            var dictionaryItem: [String: Any] = [:]
            
            //time in seconds
            let stepTime = step["duration"]["value"].intValue
            date = date.addingTimeInterval(TimeInterval(stepTime))
            dictionaryItem["time"] = date.timeIntervalSince1970.rounded()
            
            //add latitude and longitude in WGS84 format
            dictionaryItem["long"] = step["end_location"]["lat"].stringValue
            dictionaryItem["lat"] = step["end_location"]["lng"].stringValue
            
            listarray.append(dictionaryItem)
        }
        
        let parameters: Parameters = ["List" : listarray]
        
        let AWSURL = url.AWS_WEATHER_URL
        //make url request to AWS Weather Fuction
        Alamofire.request(AWSURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON(completionHandler: {
            (response) in
            
            switch response.result {
                
            case .success(let json):
                guard let responseJSON = json as? [[String:Any]] else{
                    break;
                }
                completion(responseJSON)
                
            case .failure(let error):
                print(error)
                let title = "Invalid Route"
                let message = "Woops! Our bad, looks like there was an issue procesing your route"
                
                self.alertTool(title: title, message: message)
            }
        })
    }
    
    /**
     Calls the AWS Lambda Reverse Geolocation API to get the location name at each directions step
     - parameters:
     - steps: The array containing each direction step
     - completion: Allows the Alamofire request to complete before returning
     */
    func getLocationName(steps: [JSON], completion: @escaping () -> ()) {
        
        //create array of dictionaries for each individual coordinate
        var listarray: [[String: Any]] = []
        for step in steps {
            var dictionaryItem: [String: Any] = [:]
            //add lat and long coordinate pairs
            dictionaryItem["lat"] = step["end_location"]["lat"].stringValue
            dictionaryItem["long"] = step["end_location"]["lng"].stringValue
            listarray.append(dictionaryItem)
        }
        
        
        //create dictionary of coordinates with key being list
        let coordinatesJSON: Parameters = ["list" : listarray]
        let urlComplete = url.AWS_REVERSE_GEOLOCATION_URL
        
        //make API call to AWS Lambda Reverse Geolocating function
        Alamofire.request(urlComplete, method: .post, parameters: coordinatesJSON, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON(completionHandler: {
            (response) in
            
            switch response.result {
                
            case .success(let JSON):
                
                //An array is returned so cast the response as an array
                guard let jsonData = JSON as? [String] else{
                    break;
                }
                //append response array to cities array
                self.cities.append(contentsOf: jsonData)
                completion()
                
            case .failure(let error):
                print(error)
                let title = "Routing Issue"
                let message = "Woops! Our bad, looks like there was an issue procesing your route"
                
                self.alertTool(title: title, message: message)
                
            }
        })
        
    }
    
    func getDirections(url: String, completion: @escaping ([JSON]) -> ()){
        
        Alamofire.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            
            //begin parsing the response
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            completion(routes)
        }
    }
    
}
