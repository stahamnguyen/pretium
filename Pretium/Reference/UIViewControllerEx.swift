//
//  UIViewControllerEx.swift
//  Pretium
//
//  Created by Staham Nguyen on 10/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappingAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyBoard() {
        view.endEditing(true)
    }
}
