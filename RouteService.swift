//
//  RouteService.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/9/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation
import GoogleMaps

let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
var routes: [Any] = []
var overviewPolyline: String!

extension ViewController {
    func getDirection(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let mapsURL = baseURLDirections + "origin=\(source.latitude),\(source.longitude)&desintation=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving"
        let url = URL(string: mapsURL)!
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do{
                    if let json: [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        routes = (json["routes"] as? [Any])!
                        let polyline = routes[0] as?[String:Any]
                        overviewPolyline = (polyline!["points"] as?String)!
                    }
                }catch{
                    print("Error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func showDirectionsPath(){
        let path = GMSPath(fromEncodedPath: overviewPolyline)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView
    }
}
