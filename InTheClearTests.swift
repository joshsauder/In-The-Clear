//
//  InTheClearTests.swift
//  InTheClearTests
//
//  Created by Josh Sauder on 3/10/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import XCTest
@testable import InTheClear
import GoogleMaps
import SwiftyJSON

class InTheClearTests: XCTestCase {
    
    let vc = ViewController()
    
    
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
    }

    /*
     Test that will input two locations that you can drive to and from.
     Should return a valid route
    */
    func testNormalRoute() {
        
        //Detroit, MI coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 42.33168)!, longitude: CLLocationDegrees(exactly: -83.048)!)
        
        //Columbus, OH coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 39.96199)!, longitude: CLLocationDegrees(exactly: -83.00275)!)
        
        vc.createLine(startLocation: start, endLocation: destination) {condition in
            //if there is a valid route, the associated polyline will be added to the polyline array
            assert(self.vc.polylineArray.count > 0)
        }
        
        
    }
    
    /*
     Test that will input two locations that you cannot drive to and from
     Should return nothing, and should not error out
    */
    func testOverseasRoute(){
        
        //Madrid, Spain coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 40.42028)!, longitude: CLLocationDegrees(exactly: -3.70577)!)
        
        //Los Angeles, CA coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 34.05349)!, longitude: CLLocationDegrees(exactly: -118.24532)!)
        
        vc.createLine(startLocation: start, endLocation: destination){ condition in
            assert(self.vc.polylineArray.count == 0)
        }
        
    }

    /*
     Test that will check to ensure line is being drawn correctly
    */
    func testRouteLine(){
        
        //Detroit, MI coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 42.33168)!, longitude: CLLocationDegrees(exactly: -83.048)!)
        
        //Columbus, OH coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 39.96199)!, longitude: CLLocationDegrees(exactly: -83.00275)!)
        
        vc.createLine(startLocation: start, endLocation: destination){ condition in
            let path = self.vc.polylineArray[0].path
            
            //get coordinates
            let startCoordinates = path?.coordinate(at: UInt(0))
            let endCoordinates = path?.coordinate(at: UInt((path?.count())!-1))
            
            //make sure start and end coordinates are equal
            assert(startCoordinates?.latitude == CLLocationDegrees(exactly: 42.33168))
            assert(startCoordinates?.longitude == CLLocationDegrees(exactly: -83.048))
            
            assert(endCoordinates?.latitude == CLLocationDegrees(exactly: 39.96199))
            assert(endCoordinates?.longitude == CLLocationDegrees(exactly: -83.00275))
        }
        

    }
    
    /*
     Test that will input a second route and will ensure first route is removed
    */
    func testSecondRoute(){
        
        //Detroit, MI coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 42.33168)!, longitude: CLLocationDegrees(exactly: -83.048)!)
        
        //Columbus, OH coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 39.96199)!, longitude: CLLocationDegrees(exactly: -83.00275)!)
        
        vc.createLine(startLocation: start, endLocation: destination){ condition in
            assert(self.vc.polylineArray.count == 1)
        }
        
        //Miami, FL coordinates
        let secondStart = CLLocation(latitude: CLLocationDegrees(exactly: 25.77481)!, longitude: CLLocationDegrees(exactly: -80.19773)!)
        
        //Columbus, OH coordinates
        let secondDestination = CLLocation(latitude: CLLocationDegrees(exactly: 32.77815)!, longitude: CLLocationDegrees(exactly: -96.7954)!)
        
        vc.createLine(startLocation: secondStart, endLocation: secondDestination){condition in
            assert(self.vc.polylineArray.count == 1)
        }
        
        //if there is a valid route, the associated polyline will be added to the polyline array
    }

}
