# In The Clear
In The Clear is an iOS directions app that shows the user the weather they can expect as they are driving. It not only shows the weather via the Google Maps polyline (directions path displayed on map), but also in a table that shows the weather in each city the user will be driving through. If you are ever driving over a long distance, especially if you're traveling through an area that commonly receives unfavorable weather, this app can be a great tool that can help you predict what weather conditions you can expect to drive through. 

There is a backend service that utilized AWS Lambda, and NodeJS. Currently there are two Lambda functions that handle all weather and reverse geocoding requests. The following [link](https://github.com/joshsauder/InTheClearBackend) will take you to the In The Clear Backend Github Repo.

## Requirements
- iOS 12.0+
- XCode 10.0+
- Swift 4.0

## Getting Started

### Download Repository from Github
Clone the repository from Github:

```bash
git clone https://github.com/joshsauder/In-The-Clear.git
```

Clone each submodule:

```bash
cd In-The-Clear
git submodule update --init --recursive
```

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
To run this project you will need an API key for GoogleMaps, Google Places, Google Directions, HERE Maps, and AWS. The AWS API keys must be provided by me (Josh Sauder), but the other four keys will need to be obtained from Google and HERE Maps. Create a Constants.swift file inside InTheClear/Constants and set it up like below:

```swift
struct Constants {
    static let AWS_KEY = "<AWS KEY>"
    static let GOOGLE_MAPS_KEY = "<Google Maps Key>"
    static let GOOGLE_PLACES_KEY = "<Google Places Key>"
    static let GOOGLE_DIRECTIONS_KEY = "<Google Directions Key>"
    static let HERE_APPID = "<HERE Maps App ID>"
    static let HERE_APPCODE = "<HERE Maps App Code>"
}
```

All that's left to do is to open 'InTheClear.xcworkspace' and you should be good to go!
