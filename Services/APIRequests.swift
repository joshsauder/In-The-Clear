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
import CoreLocation

extension ViewController {
    
    struct TripPostData: Encodable {
        let userId: Int
        let duration: Int
        let distance: Int
        let locations: [LocationData]
        
    }
    
    struct LocationData: Encodable {
        let city: String
        let condition: String
        let temperature: Int
    }
    /**
     Calls the AWS Lambda Weather API service and populates the weather array
     
     - parameters:
        - parameters: The API request body
        - completion: After request made, exit with the condition at specified time
     */
    func getWeather(parameters: Parameters, completion: @escaping ([[String: Any]]) -> ()) {
        
        let AWSURL = url.AWS_WEATHER_URL
        //make url request to AWS Weather Fuction
        AF.request(AWSURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON(completionHandler: {
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
        AF.request(urlComplete, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON(completionHandler: {
            (response) in
            
            switch response.result {
                
            case .success(let JSON):
                
                //An array is returned so cast the response as an array
                guard let jsonData = JSON as? [String] else{
                    break;
                }
                //append response array to cities array
                self.tripData.cities.append(contentsOf: jsonData)
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
        
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            
            //begin parsing the response
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            completion(routes)
        }
    }
    
    func postTrip(tripData: tripDataModal, distance: Int, duration: Int){
        var locationData : [LocationData] = []
        for (index, stop) in tripData.stops.enumerated(){
            let location = LocationData(city: stop, condition: tripData.conditions[index], temperature: Int(tripData.highTemps[index]))
            locationData.append(location)
        }
        
        let postData = TripPostData(userId: UserDefaults.standard.integer(forKey: Defaults.id), duration: duration, distance: distance, locations: locationData)
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + getAccessToken()]
        AF.request("http://localhost:5000/api/Trip", method: .post, parameters: postData, encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { response in
            
            print(response.response?.statusCode)
        }
    }
    
    private func getAccessToken() -> String {
        let manager = RealmManager()
        
        let user = manager.getUser()
        return user.token
    }
}
