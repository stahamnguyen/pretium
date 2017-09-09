//
//  CellInWeatherVC.swift
//  Pretium
//
//  Created by Staham Nguyen on 06/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CellInWeatherVC: UITableViewCell {
    let dateLabel = UILabel()
    let weatherStatusImageView = UIImageView()
    let highestTemperatureLabel = UILabel()
    let lowestTemperatureLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup(label: dateLabel, withFrameX: 23, y: 16.5, width: 120, height: 23, textAlignment: .left, textColor: .white, fontSizeIphone5: 14, fontSizeIphone6: 16, fontSizeIphone6Plus: 18, text: "N/A")
        
        weatherStatusImageView.frame = Create.frameScaledToIphone6Plus(x: 187, y: 16.5, width: 31, height: 23)
        weatherStatusImageView.image = UIImage(named: "cloudy")
        weatherStatusImageView.contentMode = .scaleAspectFit
        addSubview(weatherStatusImageView)
        
        setup(label: highestTemperatureLabel, withFrameX: 263, y: 16.5, width: 60, height: 23, textAlignment: .right, textColor: .white, fontSizeIphone5: 14, fontSizeIphone6: 16, fontSizeIphone6Plus: 18, text: "N/A")
        setup(label: lowestTemperatureLabel, withFrameX: 331, y: 16.5, width: 60, height: 23, textAlignment: .right, textColor: .lightGray, fontSizeIphone5: 14, fontSizeIphone6: 16, fontSizeIphone6Plus: 18, text: "N/A")
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(label: UILabel, withFrameX x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, textAlignment: NSTextAlignment, textColor: UIColor, fontSizeIphone5: CGFloat, fontSizeIphone6: CGFloat, fontSizeIphone6Plus: CGFloat, text: String) {
        label.frame = Create.frameScaledToIphone6Plus(x: x, y: y, width: width, height: height)
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: fontSizeIphone5, forIphone6: fontSizeIphone6, forIphone6Plus: fontSizeIphone6Plus))
        addSubview(label)
        label.text = text
    }
    
}
