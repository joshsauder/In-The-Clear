//
//  FirestoreManager.swift
//  InTheClear
//
//  Created by Josh Sauder on 11/9/21.
//  Copyright © 2021 Josh Sauder. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirestoreManager {
    private let db = Firestore.firestore()
    let DATE_FORMAT = "yyyy-MM-dd HH:mm:ss"
    let USER_TABLE = "user"
    let TRIP_TABLE = "trip"
    
    func addUser(userData: UserData, expiration: String = "") {
        let user = FirebaseUser(name: userData.name, email: userData.email, dateJoined: userData.dateJoined.toString(dateFormat: DATE_FORMAT), planExpiration: expiration)
        do {
            try db.collection(USER_TABLE).document(userData.id).setData(from: user)
            try db.collection(TRIP_TABLE).document(userData.id).setData([
                "trips": []
            ])
        } catch _ {
            print("Error while adding user")
        }
    }
    
    func getUser(userId: String, completion: @escaping (FirebaseUser?, DocumentReference) -> Void) {
        let docRef = db.collection(USER_TABLE).document(userId)
        docRef.getDocument { (document, error) in
            let result = Result{
                try document?.data(as: FirebaseUser.self)
            }
            
            switch result {
            case .success(let user):
                if let user = user {
                    completion(user, docRef)
                } else {
                    completion(nil, docRef)
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
                completion(nil, docRef)
            }
            
        }
    }
    
    func updatePaid(userId: String){
        let docRef = db.collection(USER_TABLE).document(userId)
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print(futureDate!.toString(dateFormat: self.DATE_FORMAT))
        docRef.updateData([
            "planExpiration": futureDate!.toString(dateFormat: self.DATE_FORMAT)
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func postTrip(userId: String, tripData: FirebaseTripData){
        let docRef = db.collection(TRIP_TABLE).document(userId)
        docRef.updateData([
            "trips": FieldValue.arrayUnion([tripData.dictionary])
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func getTrips(userId: String, completion: @escaping (FirebaseTrips?) -> Void){
        let docRef = db.collection(TRIP_TABLE).document(userId)
        docRef.getDocument { (document, error) in
            let result = Result{
                try document?.data(as: FirebaseTrips.self)
            }
            
            switch result {
            case .success(let trips):
                if let trips = trips {
                    completion(trips)
                } else {
                    completion(nil)
                }
            case .failure(let error):
                print("Error decoding trips: \(error)")
                completion(nil)
            }
        }
    }
}
