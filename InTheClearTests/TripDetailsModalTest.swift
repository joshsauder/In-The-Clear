//
//  TripDetailsModalTest.swift
//  InTheClearTests
//
//  Created by Josh Sauder on 2/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import XCTest
import CoreLocation

@testable import InTheClear

class TripDetailsModalTest: XCTestCase {
    
    var modal = tripDetailsModal()
    let cityStops = ["test1", "test2", "test3"]
    let cityLocations = [CLLocation(latitude: CLLocationDegrees(exactly: 47.6062)!, longitude: CLLocationDegrees(exactly: 122.3321)!),
    CLLocation(latitude: CLLocationDegrees(exactly: 50.6062)!, longitude: CLLocationDegrees(exactly: 132.3321)!),
    CLLocation(latitude: CLLocationDegrees(exactly: 60.6062)!, longitude: CLLocationDegrees(exactly: 152.3321)!)]
    let startTimes = [Date().addingTimeInterval(100), Date().addingTimeInterval(200), Date().addingTimeInterval(300)]
    
    override func setUp() {
        super.setUp()
        modal.cityStops = cityStops
        modal.cityLocations = cityLocations
        modal.startTimes = startTimes
    }
    override func tearDown() {
        super.tearDown()
    }
    
    /**
     Test reorder of items when the city inputs are reordered
     */
    func testReorderItems(){
        modal.reorderItems(startIndex: 0, destIndex: 1)
        
        XCTAssertTrue(modal.cityStops[1] == cityStops[0])
        XCTAssertTrue(modal.cityLocations[1] == cityLocations[0])
        XCTAssertTrue(modal.startTimes[1] == startTimes[0])
        
    }
    
    /**
    Test reorder of items when a city input is removed
    */
    func testRemoveItems(){
        modal.removeItems(index: 2)
        
        XCTAssertTrue(!modal.cityStops.contains(cityStops[2]))
        XCTAssertTrue(!modal.cityLocations.contains(cityLocations[2]))
        XCTAssertTrue(!modal.startTimes.contains(startTimes[2]))
            
    }
    
    /**
    Test reorder of items when a new city is added
    */
    func testAddItem(){
        let loc = CLLocation(latitude: CLLocationDegrees(exactly: 60.6062)!, longitude: CLLocationDegrees(exactly: 152.3321)!)
        let city = "testNew"
        
        modal.addCity(city: city, loc: loc, index: 1)
        
        XCTAssertTrue(modal.cityStops[1] == city)
        XCTAssertTrue(modal.cityLocations[1] == loc)
        XCTAssertEqual(modal.startTimes[1].timeIntervalSinceReferenceDate, Date().timeIntervalSinceReferenceDate, accuracy: 0.05)
        
    }
}
