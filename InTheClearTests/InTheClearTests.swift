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
import Alamofire

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
     Should return a valid route and a time and distance value
    */
    func testNormalRoute() {
        
        //Detroit, MI coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 42.33168)!, longitude: CLLocationDegrees(exactly: -83.048)!)
        
        //Columbus, OH coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 39.96199)!, longitude: CLLocationDegrees(exactly: -83.00275)!)
        
        vc.createLine(startLocation: start, endLocation: destination, time: Date()) {time, distance in
            //if there is a valid route, the associated polyline will be added to the polyline array
            assert(self.vc.polylineArray.count != 0)
            assert(time != 0)
            assert(distance != 0.0)
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
        
        vc.createLine(startLocation: start, endLocation: destination, time: Date()){ _, _ in
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
        
        vc.createLine(startLocation: start, endLocation: destination, time: Date()){ _, _ in
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
        
        vc.createLine(startLocation: start, endLocation: destination, time: Date()){ _, _ in
            assert(self.vc.polylineArray.count == 1)
        }
        
        //Miami, FL coordinates
        let secondStart = CLLocation(latitude: CLLocationDegrees(exactly: 25.77481)!, longitude: CLLocationDegrees(exactly: -80.19773)!)
        
        //Columbus, OH coordinates
        let secondDestination = CLLocation(latitude: CLLocationDegrees(exactly: 32.77815)!, longitude: CLLocationDegrees(exactly: -96.7954)!)
        
        vc.createLine(startLocation: secondStart, endLocation: secondDestination, time: Date()){_, _ in
            assert(self.vc.polylineArray.count == 1)
        }
        
        //if there is a valid route, the associated polyline will be added to the polyline array
    }
    
    /**
     Test Weather Lambda Function
     Should return weather data for two cities. Also checks to ensure time is added correctly
    */
    func testWeatherFunction(){
        //San Diego and Oceanside coordinates
        let latArray:[String] = ["32.715904","33.192065"]
        let longArray:[String] = ["-117.167608", "-117.376427"]
        //10 minutes and 11 minutes in the future
        let timeArray:[Int] = [600, 660]
        
        let refDate = Date().timeIntervalSince1970
        let timeInterval = TimeInterval(refDate)
        var date = Date(timeIntervalSince1970: timeInterval)
        
        let testDate = timeInterval
        
        var weatherArray: [[String: Any]] = []
        
        var i = 0
        //create dictionary array for request
        while i < latArray.count {
            var dictionaryItem: [String: Any] = [:]
            
            dictionaryItem["lat"] = latArray[i]
            dictionaryItem["long"] = longArray[i]
            
            date = date.addingTimeInterval(TimeInterval(timeArray[i]))
            dictionaryItem["time"] = date.timeIntervalSince1970.rounded()
            
            weatherArray.append(dictionaryItem)
            i = i + 1
        }
        
        let weatherParameters: Parameters = ["List" : weatherArray]
        
        vc.getWeather(parameters: weatherParameters){ json in
            //assert coordinates match up
            assert(json[0]["lat"] as! String == latArray[0] && json[0]["long"] as! String == longArray[0])
            assert(json[1]["lat"] as! String == latArray[1] && json[1]["long"] as! String == longArray[1])
            //assert weather details exist
            assert(((json[0]["condition"] == nil) as! String).isEmpty && (json[0]["temp"] as! String).isEmpty)
            assert(((json[1]["condition"] == nil) as! String).isEmpty && (json[1]["temp"] as! String).isEmpty)
            //assert requestedtime is added correctly to current time
            assert(weatherArray[0]["time"] as! Int == Int(testDate) + timeArray[0])
            assert(weatherArray[1]["time"] as! Int == Int(testDate) + timeArray[1])
        }
    }
    
    /**
     Test Reverse Geocode Lambda function
     Expect two cities to be returned
    */
    func testReverseGeolocatingFunction(){
        //San Diego and Oceanside coordinates
        let latArray:[String] = ["32.715904","33.192065"]
        let longArray:[String] = ["-117.167608", "-117.376427"]
        
        var locationArray: [[String: Any]] = []
        
        var i = 0
        //create dictionary array for request
        while i < latArray.count {
            var dictionaryItem: [String: Any] = [:]
            
            dictionaryItem["lat"] = latArray[i]
            dictionaryItem["long"] = longArray[i]
            
            locationArray.append(dictionaryItem)
            i = i + 1
        }
        
        let weatherParameters: Parameters = ["List" : locationArray]
        
        vc.getLocationName(parameters: weatherParameters){
            //assert both cities are added to cities array
            assert(self.vc.tripData.cities[0] == "San Diego, CA")
            assert(self.vc.tripData.cities[1] == "Oceanside, CA")
        }
    }

}
