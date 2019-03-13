//
//  WeatherTableTests.swift
//  InTheClearTests
//
//  Created by Josh Sauder on 3/10/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import XCTest
@testable import InTheClear
import FontAwesome_swift
import GoogleMaps

class WeatherTableTests: XCTestCase {
    
    var weatherMenu: weatherMenu!
    
    override func setUp() {
        super.setUp()
    }
    
    /*
     Test to ensure correct color are being displayed
 ```*/
    func testTableCellColor() {
        
        //actual values
        let rain = weatherMenu.cellColor(weather: "Rain")
        let sun = weatherMenu.cellColor(weather: "Sun")
        let snow = weatherMenu.cellColor(weather: "Snow")
        let ts = weatherMenu.cellColor(weather: "Thunderstorm")
        let cloud = weatherMenu.cellColor(weather: "Cloud")
        
        //expected values
        let expectedRain = UIColor(red:0.35, green:0.93, blue:0.35, alpha:1.0)
        let expectedSun = UIColor(red:0.98, green:0.93, blue:0.43, alpha:1.0)
        let expectedSnow = UIColor(red:0.43, green:0.39, blue:1.00, alpha:1.0)
        let expectedTS = UIColor(red:0.89, green:0.11, blue:0.34, alpha:1.0)
        let expectedCloud = UIColor(red:0.63, green:0.62, blue:0.62, alpha:1.0)
        
        //test actual vs expected
        assert(rain == expectedRain)
        assert(sun == expectedSun)
        assert(cloud == expectedCloud)
        assert(snow == expectedSnow)
        assert(ts == expectedTS)
        
    }
    
    /*
    Test to ensure correct image are being displayed
    */
    func testTableCellImage() {
        //actual values
        let rain = weatherMenu.weatherImage(weather: "Rain")
        let sun = weatherMenu.weatherImage(weather: "Sun")
        let snow = weatherMenu.weatherImage(weather: "Snow")
        let ts = weatherMenu.weatherImage(weather: "Thunderstorm")
        let cloud = weatherMenu.weatherImage(weather: "Cloud")
        
        //expected values
        let expectedRain = UIImage.fontAwesomeIcon(
            name: .tint,
            style: .solid,
            textColor: .white,
            size: CGSize(width: 20, height: 15)
        )
        let expectedSun = UIImage.fontAwesomeIcon(
            name: .sun,
            style: .solid,
            textColor: .white,
            size: CGSize(width: 20, height: 15)
        )
        let expectedSnow = UIImage.fontAwesomeIcon(
            name: .snowflake,
            style: .solid,
            textColor: .white,
            size: CGSize(width: 20, height: 15)
        )
        let expectedTS = UIImage.fontAwesomeIcon(
            name: .bolt,
            style: .solid,
            textColor: .white,
            size: CGSize(width: 20, height: 15)
        )
        let expectedCloud = UIImage.fontAwesomeIcon(
            name: .cloud,
            style: .solid,
            textColor: .white,
            size: CGSize(width: 20, height: 15)
        )
        
        //test actual vs expected
        assert(rain == expectedRain)
        assert(sun == expectedSun)
        assert(cloud == expectedCloud)
        assert(snow == expectedSnow)
        assert(ts == expectedTS)
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
        
        vc.createLine(startLocation: start, endLocation: destination)
        
        
        //Miami, FL coordinates
        let secondStart = CLLocation(latitude: CLLocationDegrees(exactly: 25.77481)!, longitude: CLLocationDegrees(exactly: -80.19773)!)
        
        //Columbus, OH coordinates
        let secondDestination = CLLocation(latitude: CLLocationDegrees(exactly: 32.77815)!, longitude: CLLocationDegrees(exactly: -96.7954)!)
        
        vc.createLine(startLocation: secondStart, endLocation: secondDestination)
        
        var test = true
        
        //check for the first routes first and last cities
        for entry in weatherMenu.weatherDataArray {
            if entry.city == "Seattle" || entry.city == "Sacramento" {
                test = false
            }
        }
        
        assert(test)
    }
}
