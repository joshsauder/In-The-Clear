//
//  URLConfig.swift
//  InTheClear
//
//  Created by Josh Sauder on 8/22/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation

struct url {
    static let PATH_URL = "https://maps.googleapis.com/maps/api/directions/json?origin="
    static let WEATHER_URL = "http://api.openweathermap.org/data/2.5/forecast?"
    static let GOOGLEMAPS_URL = "https://www.google.co.in/maps/dir/?saddr="
    static let ARCGIS_GEOCODER_URL = "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?f=pjson&location="
    static let AWS_WEATHER_URL = "https://\(Constants.AWS_KEY).execute-api.us-east-1.amazonaws.com/Prod/weather"
    static let AWS_REVERSE_GEOLOCATION_URL = "https://\(Constants.AWS_KEY).execute-api.us-east-1.amazonaws.com/Prod/reveresegeocode"
}
