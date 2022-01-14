//
//  PersistToRealm.swift
//  InTheClear
//
//  Created by Josh Sauder on 2/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    let realm = try! Realm()
    
    /**
    Persists the user data to Realm
    - parameters:
       - user: User data to be persisted
    */
    func writeUser(user: UserData){
        try! realm.write {
            realm.deleteAll()
            realm.add(user)
        }
    }
    
    /**
     Persists the trip history to Realm
     - parameters:
        - trip: Array of trips to be persisted
     */
    func writeTrips(trip: [TripData]) {
        try! realm.write {
            //realm is reset when user info is retrieved
            realm.add(trip)
        }
    }
    
    /**
     Gets User Data from Realm
     
     - returns: The User Data
     */
    func getUser() -> UserData {
        let user = realm.objects(UserData.self).first ?? UserData()
        return user
    }
    
    /**
    Gets User Data from Realm
     
     - Parameters:
        - id: User ID
        - name : User Display Name
        - token: Access Token
        - email: User Email
        - createdAt: User creation date
        - paidDate: Date the user paid
     - returns: The User Data
    */
    func initUserData(id: String, name: String, token: String, email: String, createdAt: Date, paidDate: Date = Date()) -> UserData {
        let userData = UserData()
        userData.id = id
        userData.name = name
        userData.token = token
        userData.email = email
        userData.dateJoined = createdAt
        userData.paid = paidDate > Date()
        return userData
    }
    
    
    /**
     Fetched trip history from Realm
     - returns: Array of trip data
     */
    func getTripHistory() -> [TripData] {
        let trips = realm.objects(TripData.self).sorted(byKeyPath: "createdAt", ascending: false)
        return Array(trips)
    }
    
}
