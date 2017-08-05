//
//  CustomButton.swift
//  Pretium
//
//  Created by Staham Nguyen on 30/07/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButtonMainScreen: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        styling()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func styling() {
        layer.cornerRadius = 4
        
        titleLabel?.font = UIFont(name: "San Francisco", size: 27)
        
        if AppDelegate.isIPhone5() {
            titleLabel?.font = titleLabel?.font.withSize(21)
        } else if AppDelegate.isIPhone6() {
            titleLabel?.font = titleLabel?.font.withSize(24)
        } else if AppDelegate.isIPhone6Plus() {
            titleLabel?.font = titleLabel?.font.withSize(27)
        }
    }
    
    
    
}
