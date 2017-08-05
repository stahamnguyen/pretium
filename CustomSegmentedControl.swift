//
//  SegmentedControlEx.swift
//  Pretium
//
//  Created by Staham Nguyen on 03/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        let fontSize = UIFont.systemFont(ofSize: { () -> CGFloat in
            if AppDelegate.isIPhone5() {
                return CGFloat(11)
            } else if AppDelegate.isIPhone6() {
                return CGFloat(12)
            } else {
                return CGFloat(13)
            }
        }())
        
        setTitleTextAttributes([NSFontAttributeName: fontSize], for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
