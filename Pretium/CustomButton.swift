//
//  CustomButton.swift
//  Pretium
//
//  Created by Staham Nguyen on 30/07/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 4
        
        if AppDelegate.isIPhone5() {
            titleLabel?.font = titleLabel?.font.withSize(18)
        } else if AppDelegate.isIPhone6() {
            titleLabel?.font = titleLabel?.font.withSize(24)
        }
    }
}
