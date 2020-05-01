//
//  LoginAPIRequests.swift
//  InTheClear
//
//  Created by Josh Sauder on 1/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

struct User: Encodable {
    let paid: Bool
    let email: String
    let displayName: String
}

extension LoginController {
    
    /**
     Sends user credentials to API and validates the token
     
     - Parameters:
        - parameters: User login credentials
        - token: Access Token
        - completion: The User ID and DisplayName
     */
    func signInUser(parameters: User, token: String, completion: @escaping (String, String, String, String) -> ()){
        let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
        print(token)
        AF.request("\(url.BACKEND_URL)/User/Auth", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON {
            response in
            
            if(response.response?.statusCode != 200){
                completion("", "", "", "")
            }
            
            let json = JSON(response.data!)
            completion(json["id"].stringValue, json["displayName"].stringValue, json["email"].stringValue, json["createdAt"].stringValue)
        }
    }
    
    /**
     Gets the user trips from backend
     - parameters:
        - id: User ID
        - token: Auth token
        - completion:completion when user data persisted
     */
    func getUserTrips(id: String, token: String, completion: @escaping () -> ()){
        
        let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
        
        AF.request("\(url.BACKEND_URL)/Trip?id=\(id)", method: .get, headers: headers).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                let json = JSON(value)
                let trips = json.arrayValue.map { (trip: JSON) -> TripData in
                    let locations = trip["locations"].arrayValue.map { (location: JSON) -> Locations in
                        let loc = Locations()
                        loc.city = location["city"].stringValue
                        loc.condition = location["condition"].stringValue
                        loc.longitude = location["longitude"].doubleValue
                        loc.latitude = location["latitude"].doubleValue
                        
                        return loc
                    }
                    
                    let tripData = TripData()
                    tripData.distance = trip["distance"].stringValue
                    tripData.duration = trip["duration"].stringValue
                    tripData.createdAt = self.parseDate(date: trip["createdAt"].stringValue)
                    tripData.locations.append(objectsIn: locations)
                    
                    return tripData
                }
                self.postUserTrips(trips: trips)
                completion()
            
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    /**
    Adds Trips to Realm
    - parameters:
        - trips: The user's previous trips
    */
    private func postUserTrips(trips: [TripData]) {
        let manager = RealmManager()
        manager.writeTrips(trip: trips)
    }
    
    /**
     Parses the date string to Date object
     - parameters:
        - date: date string
     - returns: the date object
     */
    private func parseDate(date: String) -> Date {
        let dateString = String(date.prefix(10))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
}
