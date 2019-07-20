//
//  WeatherTableTests.swift
//  InTheClearTests
//
//  Created by Josh Sauder on 3/10/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import XCTest
@testable import InTheClear
import GoogleMaps

class WeatherTableTests: XCTestCase {
    
    let wm = weatherMenu()
    
    override func setUp() {
        super.setUp()
    }
    
    /*
     Test to ensure correct color are being displayed
 ```*/
    func testTableCellColor() {
        
        //actual values
        let rain = wm.cellColor(weather: "rain")
        let sun = wm.cellColor(weather: "sun")
        let snow = wm.cellColor(weather: "snow")
        let ts = wm.cellColor(weather: "danger")
        let cloud = wm.cellColor(weather: "cloudy")
        
        //expected values
        let expectedRain = [UIColor(red:0.40, green:0.73, blue:0.42, alpha:1.0), UIColor(red:0.26, green:0.63, blue:0.28, alpha:1.0)]
        let expectedSun = [UIColor(red:1.00, green:0.92, blue:0.23, alpha:1.0), UIColor(red:0.98, green:0.75, blue:0.18, alpha:1.0)]
        let expectedSnow = [UIColor(red:0.26, green:0.65, blue:0.96, alpha:1.0), UIColor(red:0.12, green:0.53, blue:0.90, alpha:1.0)]
        let expectedTS = [UIColor(red:0.94, green:0.33, blue:0.31, alpha:1.0), UIColor(red:0.90, green:0.22, blue:0.21, alpha:1.0)]
        let expectedCloud = [UIColor(red:0.56, green:0.64, blue:0.68, alpha:1.0), UIColor(red:0.38, green:0.49, blue:0.55, alpha:1.0)]
        
        //test actual vs expected
        assert(rain[0].isEqual(expectedRain[0]) && rain[1].isEqual(expectedRain[1]))
        assert(sun[0].isEqual(expectedSun[0]) && sun[1].isEqual(expectedSun[1]))
        assert(cloud[0].isEqual(expectedCloud[0]) && cloud[1].isEqual(expectedCloud[1]))
        assert(snow[0].isEqual(expectedSnow[0]) && snow[1].isEqual(expectedSnow[1]))
        assert(ts[0].isEqual(expectedTS[0]) && ts[1].isEqual(expectedTS[1]))
        
    }
    
    /*
     Test a new route being inputed. Should remove old route values and only include new
    */
    func testSecondRoute(){
        let vc = ViewController()
        
        //Seattle, WA coordinates
        let start = CLLocation(latitude: CLLocationDegrees(exactly: 47.6062)!, longitude: CLLocationDegrees(exactly: 122.3321)!)
        
        //Sacramento, CA coordinates
        let destination = CLLocation(latitude: CLLocationDegrees(exactly: 38.5816)!, longitude: CLLocationDegrees(exactly: 121.4944)!)
        
        vc.createLine(startLocation: start, endLocation: destination, date: Date()){ time, distance in
            
            //Miami, FL coordinates
            let secondStart = CLLocation(latitude: CLLocationDegrees(exactly: 25.77481)!, longitude: CLLocationDegrees(exactly: -80.19773)!)
            
            //Columbus, OH coordinates
            let secondDestination = CLLocation(latitude: CLLocationDegrees(exactly: 32.77815)!, longitude: CLLocationDegrees(exactly: -96.7954)!)
            
            vc.createLine(startLocation: secondStart, endLocation: secondDestination, date: Date()){ time, distance in
                var test = true
                
                //check for the first routes first and last cities
                for entry in self.wm.weatherDataArray {
                    if entry.city == "Seattle, WA" || entry.city == "Sacramento, CA" {
                        test = false
                    }
                }
                
                assert(test)
            }
            
        }
    }
    
}
