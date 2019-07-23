# In The Clear
In The Clear is an iOS directions app that shows the user the weather they can expect as they are driving. It not only shows the weather via the Google Maps polyline (directions path displayed on map), but also in a table that shows the weather in each city the user will be driving through. If you are ever driving over a long distance, especially if you're traveling through an area that commonly receives unfavorable weather, this app can be a great tool that can help you predict what weather conditions you can expect to drive through. 

## Requirements
- iOS 12.0+
- XCode 10.0+
- Swift 4.0

## Getting Started
### CocoaPods
Add to your 'Podfile':

```ruby
platform :ios, '12.0'

target 'InTheClear' do
  use_frameworks!

  pod 'GoogleMaps', '~> 3.0.2'
  pod 'GooglePlaces', '~> 3.0.2'
  pod 'Alamofire', '~> 4.7'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'FontAwesome.swift', '~> 1.6.0'
end
```

Then run 'pod install' you will have all the necessary CocoaPods installed.

### Setting up Google Maps, Google Places, and OpenWeatherAPI
To run this project you will need an API key for GoogleMaps, Google Places, and OpenWeatherAPI. Insert the API keys in the following locations:

Google Maps
In AppDelegate.swift:
```swift
var googleAPIKey = "Your-API-Key"
```

Google Places
In AppDelegate.swift:
```swift
var googlePlacesKey = "Your-API-Key"
```

OpenWeatherAPI
```swift
let urlComplete = urlBase + "lat=\(lat)&lon=\(long)&units=imperial&APPID=Your-API-Key"
```

All that's left to do is to open 'InTheClear.xcworkspace' and you should be good to go!