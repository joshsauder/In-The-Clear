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
    
    func writeUser(user: UserData){

        try! realm.write {
            realm.deleteAll()
            realm.add(user)
        }
    }
    
    func getUser() -> UserData {
        
        let user = realm.objects(UserData.self).first!
        
        return user
    }
    
    func initUserData(id: String, name: String, token: String) -> UserData {
        let userData = UserData()
        userData.id = id
        userData.name = name
        userData.token = token
        return userData
    }
}
