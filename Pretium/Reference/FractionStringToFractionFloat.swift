//
//  FractionStringToFractionFloat.swift
//  Pretium
//
//  Created by Staham Nguyen on 06/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func turnIntoFloatValueFrom(fractionString: String) -> Float {
        let components = fractionString.components(separatedBy: "/")
        
        if let component1 = Float(components[0]), let component2 = Float(components[1]) {
            return component1 / component2
        }
        
        return 0
    }
}
