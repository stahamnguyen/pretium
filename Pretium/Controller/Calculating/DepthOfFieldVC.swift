//
//  DepthOfFieldVC.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

private let titleOfSensorField = "Sensor"
private let titleOfFocalLengthField = "Focal Length"
private let titleOfFocalLengthUnitLabel = "mm"
private let titleOfApertureField = "Aperture"
private let titleOfUnitField = "Unit"
private let titleOfDistanceField = "Distance"

private let titleOfDepthOfField = "Depth of Field"
private let titleOfNearDistance = "Near Distance"
private let titleOfFarDistance = "Far Distance"
private let titleOfHyperfocal = "Hyperfocal Distance"
private let titleOfInFrontOfSubject = "In Front of Subject"
private let titleOfBehindSubject = "Behind Subject"

let selectionsOfSensorPicker = ["35mm Full Frame", "Crop Sensor", "Micro 4/3"]
private let selectionsOfAperturePicker = ["1.0", "1.4", "2.0", "2.8", "4.0", "4.5", "8", "11", "16", "22"]
private let selectionsOfUnitPicker = ["m/cm", "ft/in"]

class DepthOfFieldController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    private var sensorTextField = CustomPaddingTextField()
    private var apertureTextField = CustomPaddingTextField()
    private var unitTextField = CustomPaddingTextField()
    private var focalLengthTextField = CustomPaddingTextField()
    private var meterOrFootDistanceTextField = CustomPaddingTextField()
    private var centimeterOrInchDistanceTextField = CustomPaddingTextField()
    private var sensorPicker = UIPickerView()
    private var aperturePicker = UIPickerView()
    private var unitPicker = UIPickerView()
    private var greaterUnitLabel = UILabel()
    private var lesserUnitLabel = UILabel()
    
    private var depthOfFieldResult = UILabel()
    private var nearDistanceResult = UILabel()
    private var farDistanceResult = UILabel()
    private var hyperfocalResult = UILabel()
    private var inFrontOfSubject = UILabel()
    private var behindSubject = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackground()
        createInputFields()
        createOutputFields()
        
        createButton(withTitle: "Calculate")
        
        sensorPicker.backgroundColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        aperturePicker.backgroundColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        unitPicker.backgroundColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        
        hideKeyboardWhenTappingAround()
    }
    
    private func createBackground() {
        let backgroundView = RadialGradientView()
        backgroundView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: Screen.WIDTH_OF_IPHONE_6PLUS, height: Screen.HEIGHT_OF_IPHONE_6PLUS)
        backgroundView.insideColor = Colors.OF_INNER_PART_OF_GRADIENT_BACKGROUND
        backgroundView.outsideColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        view.addSubview(backgroundView)
    }
    
    private func createInputFields() {
        createSensorField()
        createFocalLengthField()
        createApertureField()
        createUnitField()
        createDistanceField()
    }
    
    private func createSensorField() {
        createLabel(withText: titleOfSensorField, color: Colors.OF_BUTTON_TITLE, x: 30, y: 107, width: 113, height: 35)
        createTextField(withTypeOfTextField: .sensor, x: 158, y: 107, width: 226, height: 35)
    }
    
    private func createFocalLengthField() {
        createLabel(withText: titleOfFocalLengthField, color: Colors.OF_BUTTON_TITLE, x: 30, y: 153, width: 113, height: 35)
        createTextField(withTypeOfTextField: .focalLength, x: 158, y: 153, width: 56.5, height: 35)
        createLabel(withText: titleOfFocalLengthUnitLabel, color: Colors.OF_BUTTON_TITLE, x: 228, y: 153, width: 35, height: 35)
    }
    
    private func createApertureField() {
        createLabel(withText: titleOfApertureField, color: Colors.OF_BUTTON_TITLE, x: 30, y: 199, width: 113, height: 35)
        createTextField(withTypeOfTextField: .aperture, x: 158, y: 199, width: 226, height: 35)
    }
    
    private func createUnitField() {
        createLabel(withText: titleOfUnitField, color: Colors.OF_BUTTON_TITLE, x: 30, y: 245, width: 113, height: 35)
        createTextField(withTypeOfTextField: .unit, x: 158, y: 245, width: 226, height: 35)
    }
    
    private func createDistanceField() {
        createLabel(withText: titleOfDistanceField, color: Colors.OF_BUTTON_TITLE, x: 30, y: 291, width: 113, height: 35)
        createTextField(withTypeOfTextField: .meterOrFootDistance, x: 158, y: 291, width: 56.5, height: 35)
        greaterUnitLabel = setupLabel(withText: "m", color: Colors.OF_BUTTON_TITLE, x: 228, y: 291, width: 35, height: 35)
        createTextField(withTypeOfTextField: .centimeterOrInchDistance, x: 261.5, y: 291, width: 56.5, height: 35)
        lesserUnitLabel = setupLabel(withText: "cm", color: Colors.OF_BUTTON_TITLE, x: 331.5, y: 291, width: 35, height: 35)
    }
    
    private func createOutputFields() {
        createDepthOfFieldResult()
        createNearDistanceLabelResult()
        createFarDistanceResult()
        createHyperfocalResult()
        createInFrontOfSubjectResult()
        createBehindSubjectResult()
    }
    
    private func createDepthOfFieldResult() {
        createLabel(withText: titleOfDepthOfField, color: Colors.OF_CONTRAST_ITEMS, x: 30, y: 361, width: 180, height: 35)
        depthOfFieldResult = setupLabel(withText: "", color: Colors.OF_BUTTON_TITLE, x: 220, y: 361, width: 164, height: 35)
    }
    
    private func createNearDistanceLabelResult() {
        createLabel(withText: titleOfNearDistance, color: Colors.OF_BUTTON_TITLE, x: 30, y: 396, width: 180, height: 35)
        nearDistanceResult = setupLabel(withText: "", color: Colors.OF_BUTTON_TITLE, x: 220, y: 396, width: 164, height: 35)
    }
    
    private func createFarDistanceResult() {
        createLabel(withText: titleOfFarDistance, color: Colors.OF_BUTTON_TITLE, x: 30, y: 431, width: 180, height: 35)
        farDistanceResult = setupLabel(withText: "", color: Colors.OF_BUTTON_TITLE, x: 220, y: 431, width: 164, height: 35)
    }
    
    private func createHyperfocalResult() {
        createLabel(withText: titleOfHyperfocal, color: Colors.OF_BUTTON_TITLE, x: 30, y: 466, width: 180, height: 35)
        hyperfocalResult = setupLabel(withText: "", color: Colors.OF_BUTTON_TITLE, x: 220, y: 466, width: 164, height: 35)
    }
    
    private func createInFrontOfSubjectResult() {
        createLabel(withText: titleOfInFrontOfSubject, color: Colors.OF_CONTRAST_ITEMS, x: 30, y: 501, width: 180, height: 35)
        inFrontOfSubject = setupLabel(withText: "", color: Colors.OF_BUTTON_TITLE, x: 220, y: 501, width: 164, height: 35)
    }
    
    private func createBehindSubjectResult() {
        createLabel(withText: titleOfInFrontOfSubject, color: Colors.OF_CONTRAST_ITEMS, x: 30, y: 536, width: 180, height: 35)
        behindSubject = setupLabel(withText: "", color: Colors.OF_BUTTON_TITLE, x: 220, y: 536, width: 164, height: 35)
    }
    
    private func createLabel(withText text: String, color: UIColor, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let label = UILabel(frame: Create.frameScaledToIphone6Plus(x: x, y: y, width: width, height: height))
        label.text = text
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 15, forIphone6: 17, forIphone6Plus: 19))
        label.textAlignment = .right
        view.addSubview(label)
    }
    
    private func setupLabel(withText text: String, color: UIColor, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UILabel {
        let label = UILabel(frame: Create.frameScaledToIphone6Plus(x: x, y: y, width: width, height: height))
        label.text = text
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 15, forIphone6: 17, forIphone6Plus: 19))
        label.textAlignment = .left
        view.addSubview(label)
        return label
    }
    
    private func createTextField(withTypeOfTextField typeOfTextField: TypeOfTextFieldInDepthOfFieldVC, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        
        //Setup text field
        let textField = CustomPaddingTextField(frame: Create.frameScaledToIphone6Plus(x: x, y: y, width: width, height: height))
        textField.backgroundColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        textField.textColor = Colors.OF_BUTTON_TITLE
        textField.tintColor = .clear
        
        //Setup toolbar
        var toolbar: UIToolbar? = UIToolbar()
        toolbar?.barTintColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        toolbar?.isTranslucent = true
        toolbar?.sizeToFit()
        //Setup "Done" button on toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissKeyBoard))
        doneButton.tintColor = Colors.OF_CONTRAST_ITEMS
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //Attach "Done" button to toolbar
        toolbar?.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolbar?.isUserInteractionEnabled = true
        
        switch typeOfTextField {
        case .sensor:
            textField.text = selectionsOfSensorPicker[0]
            attach(textField, with: sensorPicker, and: toolbar!)
            self.sensorTextField = textField
        case .aperture:
            textField.text = selectionsOfAperturePicker[0]
            attach(textField, with: aperturePicker, and: toolbar!)
            self.apertureTextField = textField
        case .unit:
            textField.text = selectionsOfUnitPicker[0]
            attach(textField, with: unitPicker, and: toolbar!)
            self.unitTextField = textField
        case .focalLength:
            setupNormal(textField, andDeinitialize: &toolbar)
            self.focalLengthTextField = textField
        case .meterOrFootDistance:
            setupNormal(textField, andDeinitialize: &toolbar)
            self.meterOrFootDistanceTextField = textField
        case .centimeterOrInchDistance:
            setupNormal(textField, andDeinitialize: &toolbar)
            self.centimeterOrInchDistanceTextField = textField
        }
        view.addSubview(textField)
    }
    
    private func attach(_ textField: UITextField, with pickerView: UIPickerView, and toolbar: UIToolbar) {
        pickerView.dataSource = self
        pickerView.delegate = self
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
    }
    
    private func setupNormal(_ textField: UITextField, andDeinitialize toolbar: inout UIToolbar?) {
        textField.keyboardType = .numberPad
        toolbar = nil
    }
    
    private func createButton(withTitle title: String) {
        let button = CustomButtonMainScreen()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 20, forIphone6: 22, forIphone6Plus: 24))
        button.setTitleColor(Colors.OF_CONTRAST_ITEMS, for: .normal)
        button.backgroundColor = Colors.OF_OUTER_PART_OF_GRADIENT_BACKGROUND
        button.layer.borderColor = Colors.OF_CONTRAST_ITEMS.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(self.calculateButtonClicked), for: .touchUpInside)
        
        view.addSubview(button)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(Create.relativeValueScaledToIphone6Plus(of: 127))-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(Create.relativeValueScaledToIphone6Plus(of: 127))-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(Create.relativeValueScaledToIphone6Plus(of: 30))-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": button]))
    }
    
    @objc private func calculateButtonClicked() {
        if let focalLength = focalLengthTextField.text, let aperture = apertureTextField.text, let distanceInGreaterUnit = meterOrFootDistanceTextField.text, let distanceInLesserUnit = centimeterOrInchDistanceTextField.text {
            
            let validDistanceInGreaterUnit = distanceInGreaterUnit == "" ? "0" : distanceInGreaterUnit
            let validDistanceInLesserUnit = distanceInLesserUnit == "" ? "0" : distanceInLesserUnit
            
            var distanceInMeter: Float = 0
            if unitTextField.text == selectionsOfUnitPicker[1] {
                distanceInMeter = Float(validDistanceInGreaterUnit)! * 0.3048 + Float(validDistanceInLesserUnit)! * 0.0254
            } else {
                distanceInMeter = Float(validDistanceInGreaterUnit)! + Float(validDistanceInLesserUnit)! / 100
            }
            
            let aperture = Float(aperture)!
            
            if focalLength != "" {
                let validFocalLength = Float(focalLength)!
                
                var photographyParameter: PhotographyParameter? = PhotographyParameter(sensorType: sensorTextField.text!, focalLengthInMillimeter: validFocalLength, aperture: aperture, distanceInMeter: distanceInMeter)
                
                let depthOfFieldMeasurement = turnAFloatFromMeterIntoMeterAndCentimeterOrFootAndInch(float: photographyParameter!.getDepthOfFieldInMeter())
                let nearDistanceMeasuremet = turnAFloatFromMeterIntoMeterAndCentimeterOrFootAndInch(float: photographyParameter!.getNearDistanceInMeter())
                let farDistanceMeasurement = turnAFloatFromMeterIntoMeterAndCentimeterOrFootAndInch(float: photographyParameter!.getFarDistanceInMeter())
                let hyperfocalMeasurement = turnAFloatFromMeterIntoMeterAndCentimeterOrFootAndInch(float: photographyParameter!.getHyperfocalDistanceInMeter())
                let inFrontOfSubjectMeasurement = turnAFloatFromMeterIntoMeterAndCentimeterOrFootAndInch(float: photographyParameter!.getInFrontSubjectInMeter())
                let behindSubjectMeasurement = turnAFloatFromMeterIntoMeterAndCentimeterOrFootAndInch(float: photographyParameter!.getBehindSubjectInMeter())
                
                switch unitTextField.text! {
                case selectionsOfUnitPicker[0]:
                    depthOfFieldResult.text = depthOfFieldMeasurement["meter"]! + " m " + depthOfFieldMeasurement["centimeter"]! + " cm"
                    nearDistanceResult.text = nearDistanceMeasuremet["meter"]! + " m " + nearDistanceMeasuremet["centimeter"]! + " cm"
                    farDistanceResult.text = farDistanceMeasurement["meter"]! + " m " + farDistanceMeasurement["centimeter"]! + " cm"
                    hyperfocalResult.text = hyperfocalMeasurement["meter"]! + " m " + hyperfocalMeasurement["centimeter"]! + " cm"
                    inFrontOfSubject.text = inFrontOfSubjectMeasurement["meter"]! + " m " + inFrontOfSubjectMeasurement["centimeter"]! + " cm"
                    behindSubject.text = behindSubjectMeasurement["meter"]! + " m " + behindSubjectMeasurement["centimeter"]! + " cm"
                default:
                    depthOfFieldResult.text = depthOfFieldMeasurement["foot"]! + " ft " + depthOfFieldMeasurement["inch"]! + " in"
                    nearDistanceResult.text = nearDistanceMeasuremet["foot"]! + " ft " + nearDistanceMeasuremet["inch"]! + " in"
                    farDistanceResult.text = farDistanceMeasurement["foot"]! + " ft " + farDistanceMeasurement["inch"]! + " in"
                    hyperfocalResult.text = hyperfocalMeasurement["foot"]! + " ft " + hyperfocalMeasurement["inch"]! + " in"
                    inFrontOfSubject.text = inFrontOfSubjectMeasurement["foot"]! + " ft " + inFrontOfSubjectMeasurement["inch"]! + " in"
                    behindSubject.text = behindSubjectMeasurement["foot"]! + " ft " + behindSubjectMeasurement["inch"]! + " in"
                }
                
                photographyParameter = nil
            }
        }
    }
    
    private func turnAFloatFromMeterIntoMeterAndCentimeterOrFootAndInch(float: Float) -> [String : String] {
        let meterPart = floor(float)
        let meterPartInString = String(format: "%.0f", meterPart)
        let centimeterPart = float.truncatingRemainder(dividingBy: 1) * 100
        let centimeterPartInString = String(format: "%.1f", centimeterPart)
        
        let floatInFoot = float * 3.28084
        let footPart = floor(floatInFoot)
        let footPartInString = String(format: "%.0f", footPart)
        let inchPart = floatInFoot.truncatingRemainder(dividingBy: 1) * 12
        let inchPartInString = String(format: "%.1f", inchPart)
        
        var lengthDictionary = [String : String]()
        lengthDictionary["meter"] = meterPartInString
        lengthDictionary["centimeter"] = centimeterPartInString
        lengthDictionary["foot"] = footPartInString
        lengthDictionary["inch"] = inchPartInString
        return lengthDictionary
    }
    
    // ---   SETUP PICKER VIEW   ---
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case self.sensorPicker:
            return selectionsOfSensorPicker.count
        case self.aperturePicker:
            return selectionsOfAperturePicker.count
        default:
            return selectionsOfUnitPicker.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        switch pickerView {
        case self.sensorPicker:
            attributedString = NSAttributedString(string: selectionsOfSensorPicker[row], attributes: [NSForegroundColorAttributeName : Colors.OF_CONTRAST_ITEMS])
        case self.aperturePicker:
            attributedString = NSAttributedString(string: selectionsOfAperturePicker[row], attributes: [NSForegroundColorAttributeName : Colors.OF_CONTRAST_ITEMS])
        default:
            attributedString = NSAttributedString(string: selectionsOfUnitPicker[row], attributes: [NSForegroundColorAttributeName : Colors.OF_CONTRAST_ITEMS])
        }
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case self.sensorPicker:
            self.sensorTextField.text = selectionsOfSensorPicker[row]
        case self.aperturePicker:
            self.apertureTextField.text = selectionsOfAperturePicker[row]
        default:
            self.unitTextField.text = selectionsOfUnitPicker[row]
            switch selectionsOfUnitPicker[row] {
            case selectionsOfUnitPicker[0]:
                greaterUnitLabel.text = "m"
                lesserUnitLabel.text = "cm"
            default:
                greaterUnitLabel.text = "ft"
                lesserUnitLabel.text = "in"
            }
        }
    }
}

private enum TypeOfTextFieldInDepthOfFieldVC {
    case sensor, aperture, unit, focalLength, meterOrFootDistance, centimeterOrInchDistance
}
