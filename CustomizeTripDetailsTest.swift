//
//  CustomizeTripDetailsTest.swift
//  InTheClearTests
//
//  Created by Josh Sauder on 8/17/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import XCTest
import GoogleMaps

@testable import InTheClear

class CustomizeTripDetailsTest: XCTestCase {
    
    let vc = CustomizeTripDetails()
    
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    /**
     Tests the Add times functions to ensure the values are being placed in the correct order
    */
    func testAddTimes(){
        let times = [0, 60, 180]
        //first time is always the first date
        var expectedDates = [Date()]
        
        for time in times {
        expectedDates.append(Calendar.current.date(byAdding: .second, value: time, to: expectedDates[expectedDates.count - 1])!)
        }
        
        vc.tripDetails.startTimes = [Date(), Date(), Date()]
        let dates = vc.addTimes(times: times)
        
        //compare each date with accuracy set
        for (index,date) in dates.enumerated() {
            XCTAssertEqual(date.timeIntervalSinceReferenceDate, expectedDates[index].timeIntervalSinceReferenceDate, accuracy: 0.05)
        }
        
    }
}
