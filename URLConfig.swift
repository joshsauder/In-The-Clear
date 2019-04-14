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
    static let ARCGIS_AUTH_URL = "https://www.arcgis.com/sharing/oauth2/token?client_id=6Jxcq0KcDnmf91VI&grant_type=client_credentials&client_secret=32e8bdd4adc6418c83e6a622d5f5af8f&f=pjson"
    static let ARCGIS_GEOCODER_URL = "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?f=pjson&location="
}
