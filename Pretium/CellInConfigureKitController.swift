//
//  CellInConfigureKitController.swift
//  Pretium
//
//  Created by Staham Nguyen on 26/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CellInConfigureKitController: UICollectionViewCell {
    
    var backgroundImage = UIImageView()
    var title = UILabel()
    var plusTitle = UILabel()
    var type: TypeOfCellInConfigureKitController = .baseCell {
        didSet {
            switch type {
            case .createCustomKitCell:
                setupCreateCustomKitCell()
            default:
                setupBaseCell()
            }
        }
    }
    
    private func setupBaseCell() {
        clipsToBounds = true
        layer.cornerRadius = 4
        
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = self.bounds
        addSubview(backgroundImage)
        
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 14, forIphone6: 16, forIphone6Plus: 18), weight: UIFontWeightBold)
        title.textColor = .white
        title.frame = Create.frameScaledToIphone6Plus(x: 25, y: 155, width: 143, height: 22)
        addSubview(title)
    }
    
    private func setupCreateCustomKitCell() {
        layer.cornerRadius = 4
        
        let border = CAShapeLayer()
        border.strokeColor = UIColor.lightGray.cgColor
        border.lineDashPattern = [10, 10]
        border.frame = self.bounds
        border.fillColor = nil
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4).cgPath
        self.layer.addSublayer(border)
        
        plusTitle.text = "+"
        plusTitle.textAlignment = .center
        plusTitle.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 30, forIphone6: 32, forIphone6Plus: 34))
        plusTitle.textColor = .blue
        plusTitle.frame = Create.frameScaledToIphone6Plus(x: 36, y: 74, width: 120, height: 25)
        addSubview(plusTitle)
        
        
        title.text = "Create your own"
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 12, forIphone6: 14, forIphone6Plus: 16))
        title.textColor = .blue
        title.frame = Create.frameScaledToIphone6Plus(x: 36, y: 104, width: 120, height: 20)
        addSubview(title)
    }
}

enum TypeOfCellInConfigureKitController {
    case baseCell, createCustomKitCell
}
