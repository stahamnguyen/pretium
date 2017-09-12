//
//  Colors.swift
//  Pretium
//
//  Created by Staham Nguyen on 01/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreData

struct Colors {
    static let OF_BUTTON_BACKGROUND = UIColor(displayP3Red: 0/255, green: 98/255, blue: 149/255, alpha: 35)
    static let OF_BUTTON_TITLE = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
    static let OF_INNER_PART_OF_GRADIENT_BACKGROUND = UIColor(displayP3Red: 62/255, green: 79/255, blue: 117/255, alpha: 1)
    static let OF_OUTER_PART_OF_GRADIENT_BACKGROUND = UIColor(displayP3Red: 32/255, green: 49/255, blue: 67/255, alpha: 1)
    static let OF_TEXT_FIELD_OF_SEARCH_BAR = UIColor(displayP3Red: 27/255, green: 44/255, blue: 62/255, alpha: 1)
    static let OF_CONTRAST_ITEMS = UIColor(displayP3Red: 242/255, green: 202/255, blue: 109/255, alpha: 1)
    static let OF_GRAY_BACKGROUND = UIColor(displayP3Red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    static let OF_TABLE_VIEW_IN_WEATHER_VC = UIColor(displayP3Red: 32/255, green: 49/255, blue: 67/255, alpha: 0.1)
}

struct Screen {
    static let WIDTH_OF_IPHONE_6PLUS: CGFloat = 414
    static let HEIGHT_OF_IPHONE_6PLUS: CGFloat = 736
    static let HEIGTH = UIScreen.main.bounds.height
    static let WIDTH = UIScreen.main.bounds.width
    static let RATIO_WITH_IPHONE_6PLUS = Screen.HEIGTH / Screen.HEIGHT_OF_IPHONE_6PLUS
}

struct Create {
    static func frameScaledToIphone6Plus(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
        let frame = CGRect(x: x * Screen.RATIO_WITH_IPHONE_6PLUS, y: y * Screen.RATIO_WITH_IPHONE_6PLUS, width: width * Screen.RATIO_WITH_IPHONE_6PLUS, height: height * Screen.RATIO_WITH_IPHONE_6PLUS)
        return frame
    }
    
    static func relativeValueScaledToIphone6Plus(of value: CGFloat) -> CGFloat {
        return value * Screen.RATIO_WITH_IPHONE_6PLUS
    }
}

//struct Current {
//    static var GEAR_MANAGEMENT_CONTROLLER: GearManagementController = GearManagementController()
//}

// ---   WEATHER API   ---

struct WeatherApi {
    static let BASE_URL_OF_CURRENT_WEATHER = "http://api.openweathermap.org/data/2.5/weather?"
    static let BASE_URL_OF_WEATHER_FORECAST = "http://api.openweathermap.org/data/2.5/forecast/daily?"
    static let LATTITUDE = "lat="
    static let LONGTITUDE_OF_OPEN_WEATHER_MAP = "&lon="
    static let FORECASTED_DAYS = "&cnt="
    static let ID = "&appid="
    static let KEY = "09b23faf0652d34cf5e3332b886e4d8d"
    
    static let BASE_URL_OF_SUNRISE_SUNSET_ORG = "http://api.sunrise-sunset.org/json?"
    static let LONGTITUDE_OF_SUNRISE_SUNSET_ORG = "&lng="
    static let DATE = "&date="
    static let TODAY = "today"
}

enum ResponseKey: String {
    case nameOfLocation = "name"
    case mainStatistic = "main"
    case humidity = "humidity"
    case temperature = "temp"
    case weatherStatus = "weather"
    
    case resultsOfGoldenHour = "results"
    case sunriseTime = "sunrise"
    case sunsetTime = "sunset"
    case civilTwilightBegin = "civil_twilight_begin"
    case civilTwilightEnd = "civil_twilight_end"
    
    case listOfForecastingData = "list"
    case forecastedDate = "dt"
    case highestTemperature = "max"
    case lowestTemperature = "min"
}

// ---   CONTEXT FOR CORE DATA

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
