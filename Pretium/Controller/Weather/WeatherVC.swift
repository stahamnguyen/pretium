//
//  WeatherVC.swift
//  Pretium
//
//  Created by Staham Nguyen on 06/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit
import CoreLocation

private let titleOfController = "Weather"
private let cellId = "cellId"

class WeatherController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    private var currentWeatherStatusImage = UIImageView()
    private var currentWeatherStatusLabel = UILabel()
    
    private var currentLocationLabel = UILabel()
    private var currentDateLabel = UILabel()
    
    private var temperatureLabel = UILabel()
    private var humidityLabel = UILabel()
    
    private var sunriseTimeLabel = UILabel()
    private var sunsetTimeLabel = UILabel()
    private var goldenHourOfSunriseLabel = UILabel()
    private var goldenHourOfSunsetLabel = UILabel()
    
    private var tableView = UITableView()
    
    private var currentWeatherManager = CurrentWeatherManager()
    private var weatherForecastManager = WeatherForecastManager()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        navigationItem.title = titleOfController
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: Colors.OF_CONTRAST_ITEMS]
        
        setupLayout()
        setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthorizationStatus()
    }
    
    
    
    // ---   SETUP UI   ---
    
    private func setupLayout() {
        createBackground()
        setupDateLabel()
        setupTemperatureAndHumidityLayout()
        setupSunriseSunsetAndGoldenHourLayout()
    }
    
    private func createBackground() {
        let backgroundView = RadialGradientView()
        backgroundView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: Screen.WIDTH_OF_IPHONE_6PLUS, height: Screen.HEIGHT_OF_IPHONE_6PLUS)
        backgroundView.insideColor = Colors.OF_INNER_PART_OF_GRADIENT_BACKGROUND
        backgroundView.outsideColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        view.addSubview(backgroundView)
    }
    
    private func setupCurrentWeatherStatusLayout() {
        setupCurrentWeatherStatusImage()
        setupCurrentWeatherStatusLabel()
    }
    
    private func setupCurrentWeatherStatusImage() {
        setup(imageView: currentWeatherStatusImage, withFrameX: 28, y: 111, width: 107, height: 107, imageName: currentWeatherManager.weatherStatus.lowercased())
    }
    
    private func setupCurrentWeatherStatusLabel() {
        setup(label: currentWeatherStatusLabel, withFrameX: 28, y: 223, width: 107, height: 25, textAlignment: .center, textColor: .white, fontSizeIphone5: 14, fontSizeIphone6: 16, fontSizeIphone6Plus: 18, text: currentWeatherManager.weatherStatus)
    }
    
    private func setupLocationLabel() {
        setup(label: currentLocationLabel, withFrameX: 167, y: 111, width: 224, height: 35, textAlignment: .left, textColor: .white, fontSizeIphone5: 24, fontSizeIphone6: 26, fontSizeIphone6Plus: 28, text: currentWeatherManager.cityName)
    }
    
    private func setupDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        
        let dayOfToday = getDayOfWeek()!
        let fullDay = dayOfToday + ", " + currentDate
        
        setup(label: currentDateLabel, withFrameX: 167, y: 150, width: 157, height: 25, textAlignment: .left, textColor: .white, fontSizeIphone5: 14, fontSizeIphone6: 16, fontSizeIphone6Plus: 18, text: fullDay)
    }
    
    private func setupTemperatureAndHumidityLayout() {
        setupTemperatureImage()
        setupHumidityImage()
    }
    
    private func setupTemperatureImage() {
        let imageView = UIImageView()
        setup(imageView: imageView, withFrameX: 147, y: 208, width: 21, height: 35, imageName: "temperature")
    }
    
    private func setupTemperatureLabel() {
        let temperature = currentWeatherManager.currentTemperature + "°C"
        setup(label: temperatureLabel, withFrameX: 171, y: 198, width: 95, height: 51, textAlignment: .left, textColor: .white, fontSizeIphone5: 30, fontSizeIphone6: 36, fontSizeIphone6Plus: 38, text: temperature)
    }
    
    private func setupHumidityImage() {
        let imageView = UIImageView()
        setup(imageView: imageView, withFrameX: 270, y: 208, width: 21, height: 35, imageName: "humidity")
    }
    
    private func setupHumidityLabel() {
        let humidity = currentWeatherManager.currentHumidity + "%"
        setup(label: humidityLabel, withFrameX: 294, y: 198, width: 110, height: 51, textAlignment: .left, textColor: .white, fontSizeIphone5: 30, fontSizeIphone6: 36, fontSizeIphone6Plus: 38, text: humidity)
    }
    
    private func setupSunriseSunsetAndGoldenHourLayout() {
        setupSunriseLabel()
        setupSunsetLabel()
        setupGolderHourLabel()
    }
    
    private func setupSunriseLabel() {
        let label = UILabel()
        setup(label: label, withFrameX: 30, y: 273, width: 100, height: 24, textAlignment: .left, textColor: .white, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: "Sunrise:")
    }
    
    private func setupSunsetLabel() {
        let label = UILabel()
        setup(label: label, withFrameX: 30, y: 297, width: 100, height: 24, textAlignment: .left, textColor: .white, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: "Sunset:")
    }
    
    private func setupGolderHourLabel() {
        let label = UILabel()
        setup(label: label, withFrameX: 30, y: 321, width: 100, height: 24, textAlignment: .left, textColor: Colors.OF_CONTRAST_ITEMS, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: "Golden hour:")
    }
    
    private func setupSunriseSunsetAndGoldenHourTimeLayout() {
        setupSunriseTimeLabel()
        setupSunsetTimeLabel()
        setupGolderHourTimeLabel()
    }
    
    private func setupSunriseTimeLabel() {
        setup(label: sunriseTimeLabel, withFrameX: 224, y: 273, width: 160, height: 24, textAlignment: .right, textColor: .white, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: currentWeatherManager.sunriseTime)
    }
    
    private func setupSunsetTimeLabel() {
        setup(label: sunsetTimeLabel, withFrameX: 224, y: 297, width: 160, height: 24, textAlignment: .right, textColor: .white, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: currentWeatherManager.sunsetTime)
    }
    
    private func setupGolderHourTimeLabel() {
        let goldenHourSunriseTime = currentWeatherManager.civilTwilightBegin + " - " + currentWeatherManager.sunriseTime
        let goldenHourSunsetTime = currentWeatherManager.sunsetTime + " - " + currentWeatherManager.civilTwilightEnd
        
        setup(label: goldenHourOfSunriseLabel, withFrameX: 234, y: 321, width: 150, height: 24, textAlignment: .right, textColor: Colors.OF_CONTRAST_ITEMS, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: goldenHourSunriseTime)
        
        setup(label: goldenHourOfSunsetLabel, withFrameX: 234, y: 345, width: 150, height: 24, textAlignment: .right, textColor: Colors.OF_CONTRAST_ITEMS, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: goldenHourSunsetTime)
    }
    
    private func setup(label: UILabel, withFrameX x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, textAlignment: NSTextAlignment, textColor: UIColor, fontSizeIphone5: CGFloat, fontSizeIphone6: CGFloat, fontSizeIphone6Plus: CGFloat, text: String) {
        label.frame = Create.frameScaledToIphone6Plus(x: x, y: y, width: width, height: height)
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: fontSizeIphone5, forIphone6: fontSizeIphone6, forIphone6Plus: fontSizeIphone6Plus))
        view.addSubview(label)
        label.text = text
    }
    
    private func setup(imageView: UIImageView, withFrameX x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, imageName: String) {
        imageView.frame = Create.frameScaledToIphone6Plus(x: x, y: y, width: width, height: height)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.image = UIImage(named: imageName)
    }
    
    private func setupTableView() {
        tableView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 398, width: 414, height: 338)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Colors.OF_TABLE_VIEW_IN_WEATHER_VC
        tableView.separatorInset = UIEdgeInsetsMake(0, Create.relativeValueScaledToIphone6Plus(of: 23), 0, Create.relativeValueScaledToIphone6Plus(of: 23))
        view.addSubview(tableView)
        
        tableView.register(CellInWeatherVC.self, forCellReuseIdentifier: cellId)
    }
    
    private func getDayOfWeek() -> String? {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDayInInt = myCalendar.component(.weekday, from: Date())
        
        switch weekDayInInt {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        default:
            return "Sat"
        }
    }
    
    // ---   SETUP TABLEVIEW   ---
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecastManager.forecastStatisticArray.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellInWeatherVC
        let forecastData = weatherForecastManager.forecastStatisticArray[indexPath.row + 1]
        cell.dateLabel.text = forecastData.date
        cell.weatherStatusImageView.image = UIImage(named: forecastData.weatherStatus.lowercased())
        cell.highestTemperatureLabel.text = forecastData.highestTemperature + "°C"
        cell.lowestTemperatureLabel.text = forecastData.lowestTemperature + "°C"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Create.relativeValueScaledToIphone6Plus(of: 338)) / CGFloat(6)
    }
    
    // ---   UPDATING UI FROM RETRIEVED DATA   ---
    
    private func updatingUIOfCurrentWeatherStatistics() {
        setupCurrentWeatherStatusLabel()
        setupCurrentWeatherStatusImage()
        setupLocationLabel()
        setupTemperatureLabel()
        setupHumidityLabel()
    }
    
    private func updatingUIOfGoldenHour() {
        setupSunriseSunsetAndGoldenHourTimeLayout()
    }
    
    private func updateUI() {
        weatherForecastManager.forecastStatisticArray.removeAll()
        
        currentWeatherManager.processDataForWeatherStatistic {
            self.updatingUIOfCurrentWeatherStatistics()
        }
        
        currentWeatherManager.processDataForGoldenHour {
            self.updatingUIOfGoldenHour()
        }
        
        weatherForecastManager.processDataForWeatherForecastStatistic {
            self.tableView.reloadData()
        }
    }
    
    // ---   LOCATION SERVICE   ---
    private func locationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            if let latitude = currentLocation?.coordinate.latitude, let longitude = currentLocation?.coordinate.longitude {
                Location.shared.latitude = latitude
                Location.shared.longitude = longitude
                
                updateUI()
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthorizationStatus()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        Location.shared.latitude = location.coordinate.latitude
        Location.shared.longitude = location.coordinate.longitude
        
        updateUI()
    }
    
}
