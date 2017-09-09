//
//  CurrentWeatherManager.swift
//  Pretium
//
//  Created by Staham Nguyen on 08/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CurrentWeatherManager {
    private var _cityName: String!
    private var _weatherStatus: String!
    private var _currentTemperature: String!
    private var _currentHumidity: String!
    private var _sunriseTime: String!
    private var _sunsetTime: String!
    private var _civilTwilightBegin: String!
    private var _civilTwilightEnd: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = "N/A"
        }
        return _cityName
    }
    
    var weatherStatus: String {
        if _weatherStatus == nil {
            _weatherStatus = "N/A"
        }
        return _weatherStatus
    }
    
    var currentTemperature: String {
        if _currentTemperature == nil {
            _currentTemperature = "N/A"
        }
        return _currentTemperature
    }
    
    var currentHumidity: String {
        if _currentHumidity == nil {
            _currentHumidity = "N/A"
        }
        return _currentHumidity
    }
    
    var sunriseTime: String {
        if _sunriseTime == nil {
            _sunriseTime = "N/A"
        }
        return _sunriseTime
    }
    
    var sunsetTime: String {
        if _sunsetTime == nil {
            _sunsetTime = "N/A"
        }
        return _sunsetTime
    }
    
    var civilTwilightBegin: String {
        if _civilTwilightBegin == nil {
            _civilTwilightBegin = "N/A"
        }
        return _civilTwilightBegin

    }
    
    var civilTwilightEnd: String {
        if _civilTwilightEnd == nil {
            _civilTwilightEnd = "N/A"
        }
        return _civilTwilightEnd
    }
    
    func processDataForWeatherStatistic(completion: @escaping () -> ()) {
        let urlStringOfOpenWeatherMap = WeatherApi.BASE_URL_OF_CURRENT_WEATHER + WeatherApi.LATTITUDE + "\(Location.shared.latitude!)" + WeatherApi.LONGTITUDE_OF_OPEN_WEATHER_MAP + "\(Location.shared.longitude!)" + WeatherApi.ID + WeatherApi.KEY
        let url = URL(string: urlStringOfOpenWeatherMap)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, reponse, error) in
            
            if error == nil {
                if let data = data {
                    let parsedResult: Any!
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    } catch {
                        let error = error as NSError
                        print("\(error)")
                        return
                    }
                    
                    if let dataDictionary = parsedResult as? [String : Any] {
                        
                        //Name of Location
                        if let nameOfLocation = self.getData(of: .nameOfLocation, from: dataDictionary) as? String {
                            self._cityName = nameOfLocation
                        }
                        
                        //Weather status
                        if let weatherStatus = self.getData(of: .weatherStatus, from: dataDictionary) as? [Any] {
                            if let weatherStatus = weatherStatus[0] as? [String : Any], let weatherStatusDescription = self.getData(of: .mainStatistic, from: weatherStatus) as? String {
                                self._weatherStatus = weatherStatusDescription
                            }
                        }
                        
                        //Temperature and Humidity
                        if let currentWeatherMainStatistic = self.getData(of: .mainStatistic, from: dataDictionary) as? [String : Any] {
                            //Temperature
                            if let currentTemperatureInKelvin = self.getData(of: .temperature, from: currentWeatherMainStatistic) as? Float {
                                let currentTemperatureInCelcius = currentTemperatureInKelvin - Float(273)
                                self._currentTemperature = String(format: "%.0f", floorf(currentTemperatureInCelcius))
                            }
                            
                            //Humidity
                            if let currentHumidity = self.getData(of: .humidity, from: currentWeatherMainStatistic) as? Float {
                                self._currentHumidity = String(format: "%.0f", floorf(currentHumidity))
                            }
                        }
                        
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            }
        }
        
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            task.resume()
        }
    }
    
    func processDataForGoldenHour(completion: @escaping () -> ()) {
        let urlStringOfSunriseSunset = WeatherApi.BASE_URL_OF_SUNRISE_SUNSET_ORG + WeatherApi.LATTITUDE + "\(Location.shared.latitude!)" + WeatherApi.LONGTITUDE_OF_SUNRISE_SUNSET_ORG + "\(Location.shared.longitude!)" + WeatherApi.DATE + WeatherApi.TODAY
        let url = URL(string: urlStringOfSunriseSunset)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, reponse, error) in
            
            if error == nil {
                if let data = data {
                    let parsedResult: Any!
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    } catch {
                        let error = error as NSError
                        print("\(error)")
                        return
                    }
                    
                    if let dataDictionary = parsedResult as? [String : Any] {
                        
                        //Main results
                        if let mainResults = self.getData(of: .resultsOfGoldenHour, from: dataDictionary) as? [String : Any] {
                            
                            //Sunrise time
                            if let sunriseTime = self.getData(of: .sunriseTime, from: mainResults) as? String {
                                let truncatedSunriseTime = self.truncateTimeFormat(of: sunriseTime)
                                self._sunriseTime = truncatedSunriseTime
                            }
                            
                            //Sunset time
                            if let sunsetTime = self.getData(of: .sunsetTime, from: mainResults) as? String {
                                let truncatedSunsetTime = self.truncateTimeFormat(of: sunsetTime)
                                self._sunsetTime = truncatedSunsetTime
                            }
                            
                            //Civil wilight beginning time
                            if let civilTwilightBegin = self.getData(of: .civilTwilightBegin, from: mainResults) as? String {
                                let truncatedCivilTwilightBegin = self.truncateTimeFormat(of: civilTwilightBegin)
                                self._civilTwilightBegin = truncatedCivilTwilightBegin
                            }
                            
                            //Civil wilight ending time
                            if let civilTwilightEnd = self.getData(of: .civilTwilightEnd, from: mainResults) as? String {
                                let truncatedCivilTwilightEnd = self.truncateTimeFormat(of: civilTwilightEnd)
                                self._civilTwilightEnd = truncatedCivilTwilightEnd
                            }
                        }
        
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            }
        }
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            task.resume()
        }
    }
    
    private func getData(of key: ResponseKey, from data: [String : Any]) -> Any? {
        return data[key.rawValue]
    }
    
    private func truncateTimeFormat(of string: String) -> String {
        let range = string.index(string.endIndex, offsetBy: -6)..<string.index(string.endIndex, offsetBy: -3)
        var truncatedString = string
        truncatedString.removeSubrange(range)
        return truncatedString
    }
}
