//
//  CustomCellInGearManagementController.swift
//  Pretium
//
//  Created by Staham Nguyen on 20/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

private let shadowWidth = Create.relativeValueScaledToIphone6Plus(of: 0)
private let shadowHeight = Create.relativeValueScaledToIphone6Plus(of: 0)
private let shadowRadius = Create.relativeValueScaledToIphone6Plus(of: 5)

class CustomCellInGearManagementController: UICollectionViewCell {
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var amountLabel = UILabel()
    var bottomBorderOfImageView = UIView()
    var checkMarkView = CheckMarkViewInCollectionViewCell()
    var type: TypeOfCellInGearManagementController = .categoryCell {
        didSet {
            switch type {
            case .kitCell:
                imageView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 0, width: 192, height: 186)
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 4
                imageView.clipsToBounds = true
                bottomBorderOfImageView.isHidden = true
            default:
                imageView.frame = Create.frameScaledToIphone6Plus(x: 5, y: 5, width: 182, height: 175)
                imageView.contentMode = .scaleAspectFit
                imageView.layer.cornerRadius = 0
                imageView.clipsToBounds = false
                bottomBorderOfImageView.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        layer.shadowRadius = shadowRadius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        
        layer.cornerRadius = 4
        clipsToBounds = false
        
        addSubview(imageView)
        
        checkMarkView.frame = Create.frameScaledToIphone6Plus(x: 152, y: 10, width: 30, height: 30)
        checkMarkView.backgroundColor = .clear
        checkMarkView.isHidden = true
        addSubview(checkMarkView)
        
        bottomBorderOfImageView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 185.3, width: 192, height: 0.5)
        bottomBorderOfImageView.backgroundColor = .lightGray
        addSubview(bottomBorderOfImageView)
        
        nameLabel.frame = Create.frameScaledToIphone6Plus(x: 27.5, y: 188, width: 137, height: 21)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 13, forIphone6: 15, forIphone6Plus: 17), weight: UIFont.Weight.bold)
        nameLabel.textColor = .black
        addSubview(nameLabel)
        
        amountLabel.frame = Create.frameScaledToIphone6Plus(x: 27.5, y: 210, width: 137, height: 13)
        amountLabel.textAlignment = .center
        amountLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 11, forIphone6: 13, forIphone6Plus: 15))
        amountLabel.textColor = .lightGray
        addSubview(amountLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum TypeOfCellInGearManagementController {
    case categoryCell, kitCell
}
