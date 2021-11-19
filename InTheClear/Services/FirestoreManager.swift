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
    
    func addUser(userData: UserData) {
        let user = FirebaseUser(name: userData.name, email: userData.email, dateJoined: userData.dateJoined.toString(dateFormat: DATE_FORMAT), planExpiration: "")
        let newId = NSUUID().uuidString
        do {
            try db.collection(USER_TABLE).document(newId).setData(from: user)
        } catch _ {
            print("Error while adding user")
        }
    }
    
    func getUser(userId: String) -> DocumentReference {
        return db.collection(USER_TABLE).document(userId)
    }
    
    func updatePaid(userId: String){
        let userRef = getUser(userId: userId)
        
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        userRef.updateData([
            "planExpiration": futureDate!.toString(dateFormat: DATE_FORMAT)
        ])
    }
    
}
