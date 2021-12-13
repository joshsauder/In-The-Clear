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
        - completion: the directions JSON array
    */
    func getDirections(url: String, completion: @escaping ([JSON]) -> ()){
        
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            
            //begin parsing the response
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            completion(routes)
        }
    }
    
    /**
     Post Trip Details to DB
     
     - parameters:
        - tripData: The User's trip data
        - Distance: Distance of the trip
        - Duration: Time it will take to complete the trip
        - Locations: Array of CLLocations for each city
     */
    func postTrip(tripData: tripDataModal, distance: Int, duration: Int, locations: [CLLocation]){
        let fireStoreManager = FirestoreManager()
        var locationData : [LocationData] = []
        for (index, stop) in tripData.stops.enumerated(){
            //find first instance of stop and save its index
            let cityIndexes = tripData.cities.indices.filter {tripData.cities[$0].localizedCaseInsensitiveContains(stop)}
            //still need to check if cityIndex is not nil
            if cityIndexes.count > 0{
                let cityIndex = cityIndexes[0]
                let location = LocationData(city: tripData.cities[cityIndex], condition: tripData.conditions[cityIndex], longitude: locations[index].coordinate.longitude, latitude: locations[index].coordinate.latitude, temperature: Int(tripData.highTemps[cityIndex]))
                locationData.append(location)
            }
        }
        
        let userId = getUserData()
        let postData = FirebaseTripData(duration: duration, distance: distance, locations: locationData, dateAdded: Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"))
        
        fireStoreManager.postTrip(userId: userId, tripData: postData)
        addUserTrip(trip: locationData, distance: distance, duration: duration)
    }
    
    /**
     Fetches User data from Realm
     
     - returns: The access token and user ID
     */
    private func getUserData() -> String {
        let manager = RealmManager()
        
        let user = manager.getUser()
        return user.id
    }
    
    
    /**
     Adds user trip to Realm cache
     
     - parameters:
        - trip: Location data
        - distance: trip distance
        - duration: trip duration
     */
    private func addUserTrip(trip: [LocationData], distance: Int, duration: Int) {
        let manager = RealmManager()
        
        let data = TripData()
        data.createdAt = Date()
        data.distance = String(distance)
        data.duration = String(duration)
        
        let locations = trip.map{ (t) -> Locations in
            let loc = Locations()
            loc.city = t.city
            loc.condition = t.condition
            loc.latitude = t.latitude
            loc.longitude = t.longitude
            
            return loc
        }
        
        data.locations.append(objectsIn: locations)
        manager.writeTrips(trip: [data])
    }
}
