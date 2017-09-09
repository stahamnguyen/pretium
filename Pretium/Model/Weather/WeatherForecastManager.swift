//
//  WeatherForecastManager.swift
//  Pretium
//
//  Created by Staham Nguyen on 09/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import Foundation

class WeatherForecastManager {
    
    var forecastStatisticArray = [ForecastStatistic]()

    func processDataForWeatherForecastStatistic(completion: @escaping () -> ()) {
        let urlStringOfWeatherForecastStatistic = WeatherApi.BASE_URL_OF_WEATHER_FORECAST + WeatherApi.LATTITUDE + "\(Location.shared.latitude!)" + WeatherApi.LONGTITUDE_OF_OPEN_WEATHER_MAP + "\(Location.shared.longitude!)" + WeatherApi.FORECASTED_DAYS + "7" + WeatherApi.ID + WeatherApi.KEY
        let url = URL(string: urlStringOfWeatherForecastStatistic)!
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
                        
                        //Store and process retrived data in Forecast class
                        if let weatherForecastStatisticList = self.getData(of: .listOfForecastingData, from: dataDictionary) as? [[String : Any]] {
                            weatherForecastStatisticList.forEach { retrivedForecastStatistic in
                                let forecaseStatistic = ForecastStatistic(weatherForecastStatistic: retrivedForecastStatistic)
                                self.forecastStatisticArray.append(forecaseStatistic)
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
}

class ForecastStatistic {
    private var _date: String!
    private var _weatherStatus: String!
    private var _highestTemperature: String!
    private var _lowestTemperature: String!
    
    var date: String {
        if _date == nil {
            _date = "N/A"
        }
        return _date
    }
    
    var weatherStatus: String {
        if _weatherStatus == nil {
            _weatherStatus = "N/A"
        }
        return _weatherStatus
    }
    
    var highestTemperature: String {
        if _highestTemperature == nil {
            _highestTemperature = "N/A"
        }
        return _highestTemperature
    }
    
    var lowestTemperature: String {
        if _lowestTemperature == nil {
            _lowestTemperature = "N/A"
        }
        return _lowestTemperature
    }
    
    init(weatherForecastStatistic: [String : Any]) {
        // Forecasted date
        if let forecastedDate = getData(of: .forecastedDate, from: weatherForecastStatistic) as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: forecastedDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.getDayOfTheWeek()
        }
        
        // Weather status
        if let generalWeatherStatus = getData(of: .weatherStatus, from: weatherForecastStatistic) as? [[String : Any]] {
            if let mainWeatherStatus = getData(of: .mainStatistic, from: generalWeatherStatus[0]) as? String {
                self._weatherStatus = mainWeatherStatus
            }
        }
        
        // Temperature
        if let temperature = getData(of: .temperature, from: weatherForecastStatistic) as? [String : Any] {
            
            // Highest temperature
            if let highestTemperatureInKelvin = getData(of: .highestTemperature, from: temperature) as? Float {
                let highestTemperatureInCelcius = highestTemperatureInKelvin - Float(273)
                self._highestTemperature = String(format: "%.0f", floorf(highestTemperatureInCelcius))
            }
            
            // Lowest temperature
            if let lowestTemperatureInKelvin = getData(of: .lowestTemperature, from: temperature) as? Float {
                let lowestTemperatureInCelcius = lowestTemperatureInKelvin - Float(273)
                self._lowestTemperature = String(format: "%.0f", floorf(lowestTemperatureInCelcius))
            }
        }
    }
    
    private func getData(of key: ResponseKey, from data: [String : Any]) -> Any? {
        return data[key.rawValue]
    }
}
