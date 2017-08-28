//
//  NormalCell.swift
//  Pretium
//
//  Created by Staham Nguyen on 08/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CellInConfigureGearController: UITableViewCell {
    
    let borderWidth: CGFloat = 0.5
    
    var type: TypeOfCellInConfigureGearController = .categoryCell {
        didSet {
            switch type {
            case .manufacturerAndModelCell:
                setupManufacturerAndModelCell()
            case .cellWithSwitcher:
                setupCellWithSwitch()
            case .noteCell:
                setupNoteCell()
            case .cellWithTextFieldInTheRight:
                setupCellWithTextFieldOnTheRight()
            case .categoryCell:
                setupCategoryCell()
            default:
                setupBaseCell()
            }
        }
    }
    
    let mainLabel = UILabel()
    let statusLabel = UILabel()
    let statusTextField = CustomPaddingTextField()
    let usedSwitch = UISwitch()
    let noteTextView = UITextView()
    let addPhotoButton = UIButton()
    let manufacturerTextField = CustomPaddingTextField()
    let modelTextField = CustomPaddingTextField()
    let photoOfItemView = UIImageView()
    
    let titleOfButton = "Add \nphoto"
    let placeholderArray = ["Manufacturer", "Model name"]
    let defaultCategory = "Uncategorized"
    
    let sizeOfButton: CGFloat = 112
    
    //Setup cell functions

    func setupBaseCell() {
        mainLabel.frame = Create.frameScaledToIphone6Plus(x: 23, y: 17, width: 175, height: 23)
        mainLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 17, forIphone6: 19, forIphone6Plus: 21))
        addSubview(mainLabel)
    }
    
    func setupManufacturerAndModelCell() {
        //Button
        setupButton(withTitle: titleOfButton, andSize: sizeOfButton)
        
        //Manufacturer text field
        setup(textField: manufacturerTextField, withPlaceholder: placeholderArray[0], verticalPoint: 0, andHeight: sizeOfButton / 2)
        
        //Model text field
        setup(textField: modelTextField, withPlaceholder: placeholderArray[1], verticalPoint: sizeOfButton / 2, andHeight: sizeOfButton / 2)
        
        //Display photo (hidden in default)
        setupPhotoView(withPadding: 13)
    }
    
    func setupCategoryCell() {
        setupBaseCell()
        
        statusLabel.frame = Create.frameScaledToIphone6Plus(x: 198, y: 17, width: 170, height: 23)
        statusLabel.textAlignment = .right
        statusLabel.textColor = .lightGray
        statusLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 17, forIphone6: 19, forIphone6Plus: 21))
        statusLabel.text = defaultCategory
        addSubview(statusLabel)
        self.accessoryType = .disclosureIndicator
    }
    
    func setupCellWithTextFieldOnTheRight() {
        setupBaseCell()
        
        statusTextField.frame = Create.frameScaledToIphone6Plus(x: 210, y: 17, width: 196, height: 23)
        statusTextField.textAlignment = .right
        statusTextField.textColor = .lightGray
        statusTextField.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 17, forIphone6: 19, forIphone6Plus: 21))
        addSubview(statusTextField)
        self.selectionStyle = .none
    }
    
    func setupCellWithSwitch() {
        setupBaseCell()
        
        self.selectionStyle = .none
        addSubview(usedSwitch)
        
        usedSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(Create.relativeValueScaledToIphone6Plus(of: 23))-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": usedSwitch]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(Create.relativeValueScaledToIphone6Plus(of: 8))-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": usedSwitch]))
    }
    
    func setupNoteCell() {
        noteTextView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: self.frame.width / Screen.RATIO_WITH_IPHONE_6PLUS, height: self.frame.height / Screen.RATIO_WITH_IPHONE_6PLUS)
        noteTextView.textContainerInset = UIEdgeInsetsMake(Create.relativeValueScaledToIphone6Plus(of: 10), Create.relativeValueScaledToIphone6Plus(of: 18), Create.relativeValueScaledToIphone6Plus(of: 10), Create.relativeValueScaledToIphone6Plus(of: 18))
        noteTextView.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 17, forIphone6: 19, forIphone6Plus: 21), weight: UIFontWeightRegular)
        addSubview(noteTextView)
    }
    
    //Setup cell's subviews functions
    
    func setupButton(withTitle title: String, andSize size: CGFloat) {
        addPhotoButton.setTitle(title, for: .normal)
        addPhotoButton.titleLabel?.textAlignment = .center
        addPhotoButton.titleLabel?.numberOfLines = 2
        addPhotoButton.setTitleColor(.blue, for: .normal)
        addPhotoButton.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: size, height: size)
        addPhotoButton.titleLabel?.font = addPhotoButton.titleLabel?.font.withSize(AppDelegate.fontSize(forIphone5: 16, forIphone6: 18, forIphone6Plus: 20))
        addSubview(addPhotoButton)
    }
    
    func setup(textField: CustomPaddingTextField, withPlaceholder placeholder: String, verticalPoint y: CGFloat, andHeight height: CGFloat) {
        textField.placeholder = placeholder
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 17, forIphone6: 19, forIphone6Plus: 21))
        textField.frame = Create.frameScaledToIphone6Plus(x: height * 2, y: y, width: Screen.WIDTH_OF_IPHONE_6PLUS - height * 2, height: height)
        addSubview(textField)
        
        let border = CALayer()
        border.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: borderWidth / Screen.RATIO_WITH_IPHONE_6PLUS, height: sizeOfButton / 2)
        border.backgroundColor = UIColor.gray.cgColor
        textField.layer.addSublayer(border)
    }
    
    func setupPhotoView(withPadding padding: CGFloat) {
        photoOfItemView.contentMode = .scaleAspectFit
        photoOfItemView.frame = Create.frameScaledToIphone6Plus(x: padding, y: padding, width: sizeOfButton - padding * 2, height: sizeOfButton - padding * 2)
        photoOfItemView.alpha = 0
        addSubview(photoOfItemView)
    }
}

enum TypeOfCellInConfigureGearController {
    case manufacturerAndModelCell, categoryCell, cellWithSwitcher, noteCell, baseCell, cellWithTextFieldInTheRight
}
