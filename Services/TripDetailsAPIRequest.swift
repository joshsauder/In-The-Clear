//
//  TripDetailsAPIRequest.swift
//  InTheClear
//
//  Created by Josh Sauder on 8/7/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation
import SwiftyJSON

extension CustomizeTripDetails {
    
    func getTravelTime(locations: [CLLocation], completion: @escaping ([Int]) -> ()){
        
        var hereURL = url.HERE_MAPS_TRIP_TIMES_URL
        var travelTimes: [Int] = []
        
        for (index,location) in locations.enumerated() {
            hereURL.append(contentsOf: "&waypoint\(index)=geo!\(location.coordinate.latitude),\(location.coordinate.longitude)")
        }
        hereURL.append(contentsOf: "&mode=fastest;car;")
        
        Alamofire.request(hereURL, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            
            //begin parsing the response
            let json = JSON(response.data!)
            let stops = json["response"]["route"][0]["leg"].arrayValue
            
            for stop in stops {
                let time = stop["travelTime"].intValue
                travelTimes.append(time)
            }
            completion(travelTimes)
        }
    }
}
