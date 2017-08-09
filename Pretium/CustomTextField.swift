//
//  CustomTextField.swift
//  Pretium
//
//  Created by Staham Nguyen on 09/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10 * Screen.RATIO_WITH_IPHONE_7PLUS, bottom: 0, right: 10 * Screen.RATIO_WITH_IPHONE_7PLUS);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
