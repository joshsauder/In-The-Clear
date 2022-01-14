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
     Returns email and display name
     
     - Parameters:
        - parameters: User login credentials
        - token: Access Token
     */
    func signInUser(parameters: User, token: String) -> (String, String){
        print(token)
        return (parameters.displayName, parameters.email)
    }
    
    /**
     Gets the user trips from backend
     - parameters:
        - id: User ID
        - completion:completion when user data persisted
     */
    func getUserTrips(id: String, completion: @escaping () -> ()){
        let firestoreManager = FirestoreManager()
        
        firestoreManager.getTrips(userId: id) { tripsResponse in
            if let tripsResponse = tripsResponse {
                let trips = tripsResponse.trips.map { (trip: FirebaseTripData) -> TripData in
                    let locations = trip.locations.map { (location: LocationData) -> Locations in
                        let loc = Locations()
                        loc.city = location.city
                        loc.condition = location.condition
                        loc.longitude = location.longitude
                        loc.latitude = location.latitude
                        return loc
                    }
                    
                    let tripData = TripData()
                    tripData.distance = trip.distance.description
                    tripData.duration = trip.duration.description
                    tripData.createdAt = self.parseDate(date: trip.dateAdded)
                    tripData.locations.append(objectsIn: locations)
                    
                    return tripData
                }
                
                self.postUserTrips(trips: trips)
                completion()
            } else {
                self.postUserTrips(trips: [])
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
