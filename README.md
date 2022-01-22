# In The Clear

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
[![CodeFactor](https://www.codefactor.io/repository/github/joshsauder/in-the-clear/badge/master)](https://www.codefactor.io/repository/github/joshsauder/in-the-clear/overview/master)

In The Clear is an iOS directions app that shows the user the weather they can expect as they are driving. It not only shows the weather via the Google Maps polyline (directions path displayed on map), but also in a table that shows the weather in each city the user will be driving through. If you are ever driving over a long distance, especially if you're traveling through an area that commonly receives unfavorable weather, this app can be a great tool that can help you predict what weather conditions you can expect to drive through. 

There is a backend service that utilized AWS Lambda, NodeJS, and Firebase. Currently there are two Lambda functions that handle all weather and reverse geocoding requests. The following [link](https://github.com/joshsauder/InTheClearBackend) will take you to the In The Clear Backend Github Repo.

## Requirements
- iOS 13.0+
- XCode 13.0+
- Swift 5.0

## Getting Started

### Download Repository from Github
Clone the repository from Github:

```bash
git clone https://github.com/joshsauder/In-The-Clear.git
```

### CocoaPods
Add to your 'Podfile':

```ruby
platform :ios, '13.0'

target 'InTheClear' do
  use_frameworks!

  pod 'GoogleMaps', '~> 3.0.2'
  pod 'GooglePlaces'
  pod 'Alamofire', '~> 5.0.0-rc.3' 
  pod 'SwiftyJSON', '~> 4.0' 
  pod 'GoogleSignIn'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'RealmSwift', '~> 4.3.2' 
  
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

### Setting up Firebase and Apple Sign in
To run this project you will also need to set up Firebase and Apple Sign in. You will need to have a developer account with Apple in order to set this project up. I listed two links that will help you set Firebase and Apple Sign-In up:

- [Apple Sign-In](https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple)
- [Firebase](https://firebase.google.com/docs/ios/setup)

All that's left to do is to open 'InTheClear.xcworkspace' and you should be good to go!
