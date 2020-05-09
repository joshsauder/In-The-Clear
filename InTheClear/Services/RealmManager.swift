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
    Resets trip history in Realm
    */
    func resetTrips(){
        let tripObjs = realm.objects(TripData.self)
        try! realm.write {
            realm.delete(tripObjs)
        }
    }
    
    /**
     Gets User Data from Realm
     
     - returns: The User Data
     */
    func getUser() -> UserData {
        let user = realm.objects(UserData.self).first!
        return user
    }
    
    /**
    Gets User Data from Realm
     
     - Parameters:
        - id: User ID
        - Name : User Display Name
        - Token: Access Token
     - returns: The User Data
    */
    func initUserData(id: String, name: String, token: String, email: String, createdAt: Date) -> UserData {
        let userData = UserData()
        userData.id = id
        userData.name = name
        userData.token = token
        userData.email = email
        userData.dateJoined = createdAt
        return userData
    }
    
    
    /**
     Fetched trip history from Realm
     - returns: Array of trip data
     */
    func getTripHistory() -> [TripData] {
        let trips = realm.objects(TripData.self)
        return Array(trips)
    }
    
}
