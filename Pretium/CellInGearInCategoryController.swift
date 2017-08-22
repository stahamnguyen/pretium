//
//  CellInGearInCategoryController.swift
//  Pretium
//
//  Created by Staham Nguyen on 22/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CellInGearInCategoryController: UICollectionViewCell {
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var bottomBorderOfImageView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 4
        layer.borderWidth = 0.5
        clipsToBounds = true
        
        imageView.frame = Create.frameScaledToIphone6Plus(x: 5, y: 5, width: 182, height: 175)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        bottomBorderOfImageView.frame = Create.frameScaledToIphone6Plus(x: 0, y: 185.3, width: 192, height: 0.5)
        bottomBorderOfImageView.backgroundColor = .black
        addSubview(bottomBorderOfImageView)
        
        nameLabel.frame = Create.frameScaledToIphone6Plus(x: 27.5, y: 188, width: 137, height: 21)
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: AppDelegate.fontSize(forIphone5: 13, forIphone6: 15, forIphone6Plus: 17), weight: UIFontWeightBold)
        nameLabel.textColor = .black
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
