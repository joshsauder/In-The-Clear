//
//  UserData.swift
//  InTheClear
//
//  Created by Josh Sauder on 2/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import RealmSwift

class UserData: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var token = ""
    @objc dynamic var email = ""
    @objc dynamic var dateJoined: Date = Date()
}

struct FirebaseUser: Codable {
    let name: String
    let email: String
    let dateJoined: String
    let planExpiration: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case dateJoined
        case planExpiration
    }
}
