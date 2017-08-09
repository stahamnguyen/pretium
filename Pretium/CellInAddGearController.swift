//
//  NormalCell.swift
//  Pretium
//
//  Created by Staham Nguyen on 08/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CellInAddGearController: UITableViewCell {
    
    let borderWidth: CGFloat = 0.25
    
    var type: TypeOfCell = .normalCell {
        didSet {
            switch type {
            case .manufacturerAndModelCell:
                setupManufacturerAndModelCell()
            case .cellWithSwitcher:
                setupCellWithSwitch()
            case .noteCell:
                setupNoteCell()
            default:
                setupNormalCell()
            }
        }
    }
    
    let mainLabel = UILabel()
    let statusLabel = UILabel()
    let usedSwitch = UISwitch()
    let textView = UITextView()
    
    func setupManufacturerAndModelCell() {
        let addPhotoButton = UIButton()
        let manufacturerTextField = CustomTextField()
        let modelTextField = CustomTextField()
        
        addPhotoButton.setTitle("Add \nphoto", for: .normal)
        addPhotoButton.titleLabel?.textAlignment = .center
        addPhotoButton.titleLabel?.numberOfLines = 2
        addPhotoButton.setTitleColor(.blue, for: .normal)
        addPhotoButton.layer.borderColor = UIColor.gray.cgColor
        addPhotoButton.layer.borderWidth = borderWidth
        addPhotoButton.frame = CGRect(x: 0, y: 0, width: 112 * Screen.RATIO_WITH_IPHONE_7PLUS, height: 112 * Screen.RATIO_WITH_IPHONE_7PLUS)
        addPhotoButton.titleLabel?.font = addPhotoButton.titleLabel?.font.withSize(AppDelegate.fontSize(forIphone5: 16, forIphone6: 18, forIphone6Plus: 20))
        addSubview(addPhotoButton)
        
        manufacturerTextField.placeholder = "Manufacturer"
        manufacturerTextField.layer.borderWidth = borderWidth
        manufacturerTextField.layer.borderColor = UIColor.gray.cgColor
        manufacturerTextField.frame = CGRect(x: 112 * Screen.RATIO_WITH_IPHONE_7PLUS, y: 0, width: Screen.WIDTH - 112 * Screen.RATIO_WITH_IPHONE_7PLUS, height: 56 * Screen.RATIO_WITH_IPHONE_7PLUS)
        addSubview(manufacturerTextField)
        
        modelTextField.placeholder = "Model name"
        modelTextField.layer.borderWidth = borderWidth
        modelTextField.layer.borderColor = UIColor.gray.cgColor
        modelTextField.frame = CGRect(x: 112 * Screen.RATIO_WITH_IPHONE_7PLUS, y: 56 * Screen.RATIO_WITH_IPHONE_7PLUS, width: Screen.WIDTH - 112 * Screen.RATIO_WITH_IPHONE_7PLUS, height: 56 * Screen.RATIO_WITH_IPHONE_7PLUS)
        addSubview(modelTextField)
    }
    
    func setupNormalCell() {
        mainLabel.frame = CGRect(x: 23 * Screen.RATIO_WITH_IPHONE_7PLUS, y: 17 * Screen.RATIO_WITH_IPHONE_7PLUS, width: 180 * Screen.RATIO_WITH_IPHONE_7PLUS, height: 23 * Screen.RATIO_WITH_IPHONE_7PLUS)
        addSubview(mainLabel)
        
    }
    
    func setupCellWithSwitch() {
        mainLabel.frame = CGRect(x: 23 * Screen.RATIO_WITH_IPHONE_7PLUS, y: 17 * Screen.RATIO_WITH_IPHONE_7PLUS, width: 180 * Screen.RATIO_WITH_IPHONE_7PLUS, height: 23 * Screen.RATIO_WITH_IPHONE_7PLUS)
        addSubview(mainLabel)
        
        usedSwitch.frame = CGRect(x: 334 * Screen.RATIO_WITH_IPHONE_7PLUS, y: 8 * Screen.RATIO_WITH_IPHONE_7PLUS, width: 0, height: 0)
        addSubview(usedSwitch)
    }
    
    func setupNoteCell() {
        textView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        textView.textContainerInset = UIEdgeInsetsMake(10 * Screen.RATIO_WITH_IPHONE_7PLUS, 18 * Screen.RATIO_WITH_IPHONE_7PLUS, 10 * Screen.RATIO_WITH_IPHONE_7PLUS, 18 * Screen.RATIO_WITH_IPHONE_7PLUS)
        textView.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 14, forIphone6: 16, forIphone6Plus: 18), weight: UIFontWeightRegular)
        addSubview(textView)
    }
    
}

enum TypeOfCell {
    case manufacturerAndModelCell, normalCell, cellWithSwitcher, noteCell
}
