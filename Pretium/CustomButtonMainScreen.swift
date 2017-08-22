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
        titleLabel?.font = titleLabel?.font.withSize(AppDelegate.fontSize(forIphone5: 21, forIphone6: 24, forIphone6Plus: 27))
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setTitleColor(Colors.OF_BUTTON_TITLE, for: .normal)
        backgroundColor = Colors.OF_BUTTON_BACKGROUND
    }
}
