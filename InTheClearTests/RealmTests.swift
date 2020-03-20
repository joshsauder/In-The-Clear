//
//  RealmTests.swift
//  InTheClearTests
//
//  Created by Josh Sauder on 2/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import XCTest

@testable import InTheClear

class RealmTest: XCTestCase {
    
    var manager: RealmManager!
    
    override func setUp() {
        super.setUp()
        manager = RealmManager()
    }
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     Test Initialization of User Data Object
     */
    func testInit(){
        let id = "123"
        let name = "Josh"
        let token = "ABCD"
        
        let user = manager.initUserData(id: id, name: name, token: token)
        
        
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.name, name)
        XCTAssertEqual(user.token, token)
    }
    
    /**
     Test Insetion of data into Realm
     */
    func testInsertData(){
        let id = "123"
        let name = "Josh"
        let token = "ABCD"
        
        let user = manager.initUserData(id: id, name: name, token: token)
        
        manager.writeUser(user: user)
        
        let retrievedUser = manager.getUser()
        
        XCTAssertTrue(retrievedUser.isSameObject(as: user))
    }
    
    /**
     Test insertion of user data multiple times. User data should be removed each time since access token, or signed in user could be different
     */
    func testInsertofDataMultipleTimes(){
        let id = "123"
        let name = "Josh"
        let token = "ABCD"
        
        let user1 = manager.initUserData(id: id, name: name, token: token)
        
        let id2 = "456"
        let name2 = "Sauder"
        let token2 = "EFGH"
        
        let user2 = manager.initUserData(id: id2, name: name2, token: token2)
        
        //user1 should be not be retrieved once user 2 is inserted
        manager.writeUser(user: user1)
        manager.writeUser(user: user2)

        let retrievedUser = manager.getUser()
        
        XCTAssertTrue(retrievedUser.isSameObject(as: user2))
        
    }
}
