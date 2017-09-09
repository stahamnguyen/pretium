//
//  Location.swift
//  Pretium
//
//  Created by Staham Nguyen on 10/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import CoreLocation

class Location {
    
    static var shared = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
