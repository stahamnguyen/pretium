//
//  CustomTextField.swift
//  Pretium
//
//  Created by Staham Nguyen on 09/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CustomPaddingTextField: UITextField {
    
    let defaultDateOfPurchase = "Not set"

    let padding = UIEdgeInsets(top: 0, left: Create.relativeValueScaledToIphone6Plus(of: 10), bottom: 0, right: Create.relativeValueScaledToIphone6Plus(of: 10));
    
    let datePicker = UIDatePicker()
    
    var type: TypeOfTextField = .normal {
        didSet {
            switch type {
            case .datePicker:
                createDatePicker()
            case .priceSetter:
                configurePriceSetterTextField()
            default:
                return
            }
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func createDatePicker() {
        //Format for picker
        datePicker.datePickerMode = .date
        
        //Setup toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //Setup button on toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, flexibleSpace, doneButton], animated: false)
        
        //Assign date picker and toolbar to text field
        self.inputAccessoryView = toolbar
        self.inputView = datePicker
        
        self.tintColor = .clear
        if ((self.text == nil) || (self.text == "")) {
            self.text = defaultDateOfPurchase
        }
    }
    
    func donePressed() {
        //Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.text = dateFormatter.string(from: datePicker.date)
        self.endEditing(true)
    }
    
    func configurePriceSetterTextField() {
        self.addTarget(self, action: #selector(priceTextFieldDidChange), for: .editingChanged)
        self.tintColor = .clear
        self.keyboardType = .numberPad
        
        setupDefaultValueForPriceSetterInCaseEmptyOrNil()
    }
    
    func priceTextFieldDidChange() {
        if let amountString = self.text?.currencyInputFormatting() {
            self.text = amountString
        }
        
        setupDefaultValueForPriceSetterInCaseEmptyOrNil()
    }
    
    func setupDefaultValueForPriceSetterInCaseEmptyOrNil() {
        let initialNumberOfPrice: Double = 0
        let initialNumberOfPriceInString = String(format: "%.2f", [initialNumberOfPrice])
        if ((self.text == nil) || (self.text == "")) {
            self.text = Currency.unit + initialNumberOfPriceInString
        }
    }
}

enum TypeOfTextField {
    case normal, datePicker, priceSetter
}
