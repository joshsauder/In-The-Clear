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

class InTheClearTests: XCTestCase {
    
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
        
        let vc = ViewController()
        
        //Detroit, MI coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 42.33168)!, longitude: CLLocationDegrees(exactly: -83.048)!)
        
        //Columbus, OH coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 39.96199)!, longitude: CLLocationDegrees(exactly: -83.00275)!)
        
        vc.createLine(startLocation: start, endLocation: destination)
        
        //if there is a valid route, the associated polyline will be added to the polyline array
        assert(vc.polylineArray.count > 0)
        
        
    }
    
    /*
     Test that will input two locations that you cannot drive to and from
     Should return nothing, and should not error out
    */
    func testOverseasRoute(){
        
        let vc = ViewController()
        
        //Madrid, Spain coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 40.42028)!, longitude: CLLocationDegrees(exactly: -3.70577)!)
        
        //Los Angeles, CA coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 34.05349)!, longitude: CLLocationDegrees(exactly: -118.24532)!)
        
        vc.createLine(startLocation: start, endLocation: destination)
        
        //If there is not a valid route, then the polylineArray should not have any values in it
        assert(vc.polylineArray.count == 0)
        
    }

    /*
     Test that will check to ensure line is being drawn correctly
    */
    func testRouteLine(){
        
        let vc = ViewController()
        
        //Detroit, MI coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 42.33168)!, longitude: CLLocationDegrees(exactly: -83.048)!)
        
        //Columbus, OH coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 39.96199)!, longitude: CLLocationDegrees(exactly: -83.00275)!)
        
        vc.createLine(startLocation: start, endLocation: destination)
        
        let pathURL = url.PATH_URL + "42.33168,-83.048" + "&destination=" + "39.96199,-83.00275" + "&mode=driving&key=" + "AIzaSyDznbmSUzLQ7dBofWqxHg-N6_jxxFBrxy0"
    }
    
    /*
     Test that will input a second route and will ensure first route is removed
    */
    func testSecondRoute(){
        
        let vc = ViewController()
        
        //Detroit, MI coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 42.33168)!, longitude: CLLocationDegrees(exactly: -83.048)!)
        
        //Columbus, OH coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 39.96199)!, longitude: CLLocationDegrees(exactly: -83.00275)!)
        
        vc.createLine(startLocation: start, endLocation: destination)
        
        //Miami, FL coordinates
        let secondStart = CLLocation(latitude: CLLocationDegrees(exactly: 25.77481)!, longitude: CLLocationDegrees(exactly: -80.19773)!)
        
        //Columbus, OH coordinates
        let secondDestination = CLLocation(latitude: CLLocationDegrees(exactly: 32.77815)!, longitude: CLLocationDegrees(exactly: -96.7954)!)
        
        vc.createLine(startLocation: secondStart, endLocation: secondDestination)
        
        //if there is a valid route, the associated polyline will be added to the polyline array
        assert(vc.polylineArray.count == 1)
    }
    
    /*
     Ensures correct route time is being displayed
    */
    func testTotalTime(){
        
    }
    
    /*
     Test that ensures correct times are being pulled from weather service with respect to the time at which the driver will pass through
    */
    func testCorrectTimes(){
        
    }

}
