//
//  HeaderCell.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "What would you like to add?"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    let fontSize = UIFont.systemFont(ofSize: { () -> CGFloat in
        if AppDelegate.isIPhone5() {
            return CGFloat(13)
        } else if AppDelegate.isIPhone6() {
            return CGFloat(15)
        } else {
            return CGFloat(17)
        }
    }())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDisplay()
        roundUpperCorners()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDisplay() {
        backgroundColor = .white
        titleLabel.font = fontSize
        titleLabel.frame = frame
        addSubview(titleLabel)
    }
    
    func roundUpperCorners() {
        let maskPath = UIBezierPath(roundedRect: self.frame, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 4, height: 4))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.frame
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
