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
    func getWeather(parameters: Parameters, completion: @escaping ([[String: Any]]) -> ()) {
        
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
        - parameters: The API request body
        - completion: Allows the Alamofire request to complete before returning
     */
    func getLocationName(parameters: Parameters, completion: @escaping () -> ()) {
        
        let urlComplete = url.AWS_REVERSE_GEOLOCATION_URL
        
        //make API call to AWS Lambda Reverse Geolocating function
        Alamofire.request(urlComplete, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON(completionHandler: {
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
    
    /**
     Calls Google Maps Directions API Service and returns a JSON array containing directions information
     - parameters:
        - url: the full url containing lat and long coordinates
        - completions: the directions JSON array
    */
    func getDirections(url: String, completion: @escaping ([JSON]) -> ()){
        
        Alamofire.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            
            //begin parsing the response
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            completion(routes)
        }
    }
    
}
