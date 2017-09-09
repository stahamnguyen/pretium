//
//  GetDayOfTheWeek.swift
//  Pretium
//
//  Created by Staham Nguyen on 09/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import UIKit

extension Date {
    func getDayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
