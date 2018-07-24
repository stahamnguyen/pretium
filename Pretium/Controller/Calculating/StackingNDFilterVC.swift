//
//  StackingNDFilterVC.swift
//  Pretium
//
//  Created by Staham Nguyen on 06/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

private let titleOfLabel = "Shutter Speed With Filters"
private let titleOfPickerView = ["Shutter Speed", "ND Filter #1", "ND Filter #2"]
private let shutterSpeedTitle = ["1/4", "1/8", "1/15", "1/30", "1/60", "1/125", "1/250", "1/500", "1/1000", "1/2000"]
private let ndFilterTitles = ["1-Stop", "2-Stop", "3-Stop", "4-Stop", "5-Stop", "6-Stop", "7-Stop", "8-Stop", "9-Stop", "10-Stop"]
private let initialTextOfTimerLabel = "0 m 0 s"
private let initialTitleOfButton = "Show Timer"
private let titleOfButtonAfterBeingPressed = "Start Timer"
private let titleOfButtonAfterBeingPressedSecondTime = "Reset"

class StackingNDFiltersController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var picker = UIPickerView()
    private var timer = Timer()
    private var timerLabel = UILabel()
    private var button = UIButton()
    
    private var baseShutterSpeed: Float = 0.25
    private var ndFilter1Stop: Float = 1
    private var ndFilter2Stop: Float = 1
    
    private var seconds: Float = 0
    private var minutes: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackground()
        createComplementaryLabel()
        createTimerLabel()
        createButton(withTitle: initialTitleOfButton)
        createPicker()
        createPickerHeaders()
        
        hideKeyboardWhenTappingAround()
    }
    
    private func createBackground() {
        let backgroundView = RadialGradientView()
        backgroundView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: Screen.WIDTH_OF_IPHONE_6PLUS, height: Screen.HEIGHT_OF_IPHONE_6PLUS)
        backgroundView.insideColor = Colors.OF_INNER_PART_OF_GRADIENT_BACKGROUND
        backgroundView.outsideColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        view.addSubview(backgroundView)
    }
    
    private func createComplementaryLabel() {
        let label = UILabel(frame: Create.frameScaledToIphone6Plus(x: 75.5, y: 141, width: 263, height: 25))
        label.text = titleOfLabel
        label.textAlignment = .center
        label.textColor = Colors.OF_BUTTON_TITLE
        label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 17, forIphone6: 19, forIphone6Plus: 21))
        view.addSubview(label)
    }
    
    private func createTimerLabel() {
        let label = UILabel(frame: Create.frameScaledToIphone6Plus(x: 28, y: 209, width: 358, height: 76))
        label.textColor = Colors.OF_CONTRAST_ITEMS
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 55, forIphone6: 57, forIphone6Plus: 59), weight: UIFont.Weight.bold)
        label.text = initialTextOfTimerLabel
        self.timerLabel = label
        view.addSubview(timerLabel)
    }
    
    private func createButton(withTitle title: String) {
        let button = CustomButtonMainScreen()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 20, forIphone6: 22, forIphone6Plus: 24))
        button.setTitleColor(Colors.OF_CONTRAST_ITEMS, for: .normal)
        button.backgroundColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        button.layer.borderColor = Colors.OF_CONTRAST_ITEMS.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        self.button = button
        
        view.addSubview(button)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(Create.relativeValueScaledToIphone6Plus(of: Create.relativeValueScaledToIphone6Plus(of: 132)))-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(Create.relativeValueScaledToIphone6Plus(of: Create.relativeValueScaledToIphone6Plus(of: 132)))-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(Create.relativeValueScaledToIphone6Plus(of: 366))-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
    }
    
    private func createPicker() {
        let picker = UIPickerView(frame: Create.frameScaledToIphone6Plus(x: 0, y: 486, width: 414, height: 250))
        picker.dataSource = self
        picker.delegate = self
        self.picker = picker
        view.addSubview(picker)
    }
    
    private func createPickerHeaders() {
        let labelWidth = 414 / CGFloat(picker.numberOfComponents)
        for index in 0..<titleOfPickerView.count {
            let label = UILabel(frame: Create.frameScaledToIphone6Plus(x: labelWidth * CGFloat(index), y: 0, width: labelWidth, height: 20))
            label.text = titleOfPickerView[index]
            label.textColor = Colors.OF_BUTTON_TITLE
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 11, forIphone6: 13, forIphone6Plus: 15))
            picker.addSubview(label)
        }
    }
    
    private func adjustTimerLabelTextWith(initialTimeInMinute: Float, initialTimeInSecond: Float) {
        let truncatedInitialTimeInMinute = String(format: "%.0f", initialTimeInMinute)
        let truncatedInitialTimeInSecond = String(format: "%.0f", initialTimeInSecond)
        timerLabel.text = truncatedInitialTimeInMinute + " m " + truncatedInitialTimeInSecond + " s"
    }
    
    @objc private func buttonClicked() {
        //Initialize timer label
        switch (button.titleLabel?.text)! {
        case initialTitleOfButton:
            initializeTimerLabel()
        case titleOfButtonAfterBeingPressed:
            initializeTimer()
        default:
            resetTimer()
        }
    }
    
    private func initializeTimerLabel() {
        timer.invalidate() //Stop current timer's operation if any
        
        //Calculate appropriate time result for given parameters
        var stackingNdFilterCalculator: StackingNdFiltersCalculator? = StackingNdFiltersCalculator(baseShutterSpeed: baseShutterSpeed, ndFilter1Stop: ndFilter1Stop, ndFilter2Stop: ndFilter2Stop)
        let shutterSpeedWithFilters = stackingNdFilterCalculator!.calculateShutterSpeedWithFilters()
        self.minutes = shutterSpeedWithFilters["minute"]!
        self.seconds = shutterSpeedWithFilters["second"]!
        adjustTimerLabelTextWith(initialTimeInMinute: minutes, initialTimeInSecond: seconds)
        stackingNdFilterCalculator = nil
        
        //Change title of button
        button.setTitle(titleOfButtonAfterBeingPressed, for: .normal)
    }
    
    private func initializeTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimerStartingWith), userInfo: nil, repeats: true)
        button.setTitle(titleOfButtonAfterBeingPressedSecondTime, for: .normal)
    }
    
    private func resetTimer() {
        timer.invalidate()
        timerLabel.text = initialTextOfTimerLabel
        button.setTitle(initialTitleOfButton, for: .normal)
    }
    
    @objc private func updateTimerStartingWith() {
        if seconds > 0 {
            seconds -= 1
            adjustTimerLabelTextWith(initialTimeInMinute: minutes, initialTimeInSecond: seconds)
        } else {
            if minutes < 1 {
                timer.invalidate()
                button.setTitle(initialTitleOfButton, for: .normal)
            } else {
                minutes -= 1
                seconds = 59
                adjustTimerLabelTextWith(initialTimeInMinute: minutes, initialTimeInSecond: seconds)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return titleOfPickerView.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return shutterSpeedTitle.count
        default:
            return ndFilterTitles.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var attributedString: NSAttributedString!
        
        switch component {
        case 0:
            attributedString = NSAttributedString(string: shutterSpeedTitle[row], attributes: [NSAttributedStringKey.foregroundColor : Colors.OF_CONTRAST_ITEMS])
        default:
            attributedString = NSAttributedString(string: ndFilterTitles[row], attributes: [NSAttributedStringKey.foregroundColor : Colors.OF_CONTRAST_ITEMS])
        }
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        button.setTitle(initialTitleOfButton, for: .normal)
        switch component {
        case 0:
            baseShutterSpeed = turnIntoFloatValueFrom(fractionString: shutterSpeedTitle[row])
        case 1:
            ndFilter1Stop = Float(row + 1)
        default:
            ndFilter2Stop = Float(row + 1)
        }
    }
}
