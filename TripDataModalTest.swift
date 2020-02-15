//
//  TripDataModalTest.swift
//  InTheClearTests
//
//  Created by Josh Sauder on 2/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import XCTest

@testable import InTheClear

class TripDataModalTest : XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }
    
    private func setUpTest(modal: tripDataModal, stringVals: [String], floatVals: [Float]){
        modal.cities = stringVals
        modal.conditions = stringVals
        modal.highTemps = floatVals
        modal.conditionDescription = stringVals
    }
    
    /**
     Test reversal of cities, condition descriptions, conditions, and high temps
     */
    func testReverse(){
        let modal = tripDataModal()
        
        let stringVals = ["test1", "test2"]
        let floatVals = [Float(123.2), Float(123.1)]
        
        setUpTest(modal: modal, stringVals: stringVals, floatVals: floatVals)
        
        modal.reverse()
        
        XCTAssertEqual(modal.cities, stringVals.reversed())
        XCTAssertEqual(modal.conditionDescription, stringVals.reversed())
        XCTAssertEqual(modal.conditions, stringVals.reversed())
        XCTAssertEqual(modal.highTemps, floatVals.reversed())
    }
    

    /**
     Test removal of city data modal arrays
     */
    func testRemove(){
        let modal = tripDataModal()
        
        let stringVals = ["test1", "test2"]
        let floatVals = [Float(123.2), Float(123.1)]
        
        setUpTest(modal: modal, stringVals: stringVals, floatVals: floatVals)
        
        modal.removeAll()
        
        XCTAssertTrue(modal.cities.isEmpty)
        XCTAssertTrue(modal.conditions.isEmpty)
        XCTAssertTrue(modal.highTemps.isEmpty)
        XCTAssertTrue(modal.conditionDescription.isEmpty)
    }
}
