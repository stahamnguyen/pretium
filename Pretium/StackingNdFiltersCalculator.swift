//
//  StackingNdFiltersCalculator.swift
//  Pretium
//
//  Created by Staham Nguyen on 06/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import Foundation

class StackingNdFiltersCalculator {
    private let baseShutterSpeed: Float
    private let ndFilter1Stop: Float
    private let ndFilter2Stop: Float
    
    init(baseShutterSpeed: Float, ndFilter1Stop: Float, ndFilter2Stop: Float) {
        self.baseShutterSpeed = baseShutterSpeed
        self.ndFilter1Stop = ndFilter1Stop
        self.ndFilter2Stop = ndFilter2Stop
    }
    
    func calculateShutterSpeedWithFilters() -> [String:Float] {
        let shutterSpeedWithFiltersInSecond = baseShutterSpeed * powf(2, ndFilter1Stop + ndFilter2Stop)
        let truncatedShutterSpeedWithFiltersInSecond = floorf(shutterSpeedWithFiltersInSecond)
        let minutePartOfShutterSpeedWithFilters = floorf(truncatedShutterSpeedWithFiltersInSecond / 60)
        let secondPartOfShutterSpeedWithFilters = truncatedShutterSpeedWithFiltersInSecond - minutePartOfShutterSpeedWithFilters * 60
        
        var timeMeasurement = [String:Float]()
        timeMeasurement["minute"] = minutePartOfShutterSpeedWithFilters
        timeMeasurement["second"] = secondPartOfShutterSpeedWithFilters
        
        return timeMeasurement
    }
}
