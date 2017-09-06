//
//  WeatherVC.swift
//  Pretium
//
//  Created by Staham Nguyen on 06/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

private let titleOfController = "Weather"
private let cellId = "cellId"

class WeatherController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleOfController
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Colors.OF_CONTRAST_ITEMS]
        
        setupLayout()
        setupTableView()
    }
    
    // ---   SETUP UI   ---
    
    private func setupLayout() {
        createBackground()
        setupCurrentWeatherStatusLayout()
        setupLocationAndDateLayout()
        setupTemperatureAndHumidityLayout()
        setupSunriseSunsetAndGoldenHourLayout()
        setupSunriseSunsetAndGoldenHourTimeLayout()
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
        setup(imageView: currentWeatherStatusImage, withFrameX: 28, y: 111, width: 107, height: 107, imageName: "sunny")
    }
    
    private func setupCurrentWeatherStatusLabel() {
        setup(label: currentWeatherStatusLabel, withFrameX: 28, y: 223, width: 107, height: 25, textAlignment: .center, textColor: .white, fontSizeIphone5: 14, fontSizeIphone6: 16, fontSizeIphone6Plus: 18, text: "Sunny")
    }
    
    private func setupLocationAndDateLayout() {
        setupLocationLabel()
        setupDateLabel()
    }
    
    private func setupLocationLabel() {
        setup(label: currentLocationLabel, withFrameX: 167, y: 111, width: 157, height: 35, textAlignment: .left, textColor: .white, fontSizeIphone5: 24, fontSizeIphone6: 26, fontSizeIphone6Plus: 28, text: "Helsinki")
    }
    
    private func setupDateLabel() {
        setup(label: currentDateLabel, withFrameX: 167, y: 150, width: 157, height: 25, textAlignment: .left, textColor: .white, fontSizeIphone5: 14, fontSizeIphone6: 16, fontSizeIphone6Plus: 18, text: "Tue, Nov 21, 2017")
    }
    
    private func setupTemperatureAndHumidityLayout() {
        setupTemperatureLayout()
        setupHumidityLayout()
    }
    
    private func setupTemperatureLayout() {
        let imageView = UIImageView()
        setup(imageView: imageView, withFrameX: 167, y: 208, width: 21, height: 35, imageName: "temperature")
        setup(label: temperatureLabel, withFrameX: 191, y: 198, width: 75, height: 51, textAlignment: .left, textColor: .white, fontSizeIphone5: 34, fontSizeIphone6: 36, fontSizeIphone6Plus: 38, text: "36°")
    }
    
    private func setupHumidityLayout() {
        let imageView = UIImageView()
        setup(imageView: imageView, withFrameX: 270, y: 208, width: 21, height: 35, imageName: "humidity")
        setup(label: humidityLabel, withFrameX: 294, y: 198, width: 110, height: 51, textAlignment: .left, textColor: .white, fontSizeIphone5: 34, fontSizeIphone6: 36, fontSizeIphone6Plus: 38, text: "100%")
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
        let label = UILabel()
        setup(label: label, withFrameX: 234, y: 273, width: 150, height: 24, textAlignment: .right, textColor: .white, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: "7:03 am")
    }
    
    private func setupSunsetTimeLabel() {
        let label = UILabel()
        setup(label: label, withFrameX: 234, y: 297, width: 150, height: 24, textAlignment: .right, textColor: .white, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: "4:38 pm")
    }
    
    private func setupGolderHourTimeLabel() {
        let label1 = UILabel()
        let label2 = UILabel()
    
        setup(label: label1, withFrameX: 234, y: 321, width: 150, height: 24, textAlignment: .right, textColor: Colors.OF_CONTRAST_ITEMS, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: "6:25 am - 7:25 am")
        
        setup(label: label2, withFrameX: 234, y: 345, width: 150, height: 24, textAlignment: .right, textColor: Colors.OF_CONTRAST_ITEMS, fontSizeIphone5: 12, fontSizeIphone6: 14, fontSizeIphone6Plus: 16, text: "4:02 pm - 4:58 pm")
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
    
    // ---   SETUP TABLEVIEW   ---
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CellInWeatherVC
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(338) / CGFloat(6)
    }
    
}
