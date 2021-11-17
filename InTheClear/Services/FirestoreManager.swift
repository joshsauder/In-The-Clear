//
//  FirestoreManager.swift
//  InTheClear
//
//  Created by Josh Sauder on 11/9/21.
//  Copyright © 2021 Josh Sauder. All rights reserved.
//

import Foundation
import Firebase

class FirestoreManager {
    private let db = Firestore.firestore()
    let DATE_FORMAT = "yyyy-MM-dd HH:mm:ss"
    let USER_TABLE = "user"
    
    func addUser(userData: UserData) {
        let user = FirebaseUser(name: userData.name, email: userData.email, dateJoined: userData.dateJoined.toString(dateFormat: DATE_FORMAT), planExpiration: "")
        db.collection(USER_TABLE).document(user.id).setData(from: user)
    }
    
    func getUser(userId: String): DocumentReference {
        return db.collection(USER_TABLE).document(userId)
    }
    
    func updatePaid(userId: String){
        let userRef = getUser(userId: userId)
        userRef.updateData([
            "planExpiration": Date.now.toString(dateFormat: DATE_FORMAT)
        ])
    }
    
}
