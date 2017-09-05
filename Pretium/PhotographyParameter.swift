//
//  PhotographyParameter.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import Foundation

class PhotographyParameter {
    private var sensorType: String
    private var focalLengthInMillimeter: Double
    private var aperture: Double
    private var distanceInMeter: Double
    
    private var depthOfFieldInMeter: Double
    private var nearDistanceInMeter: Double
    private var farDistanceInMeter: Double
    private var hyperfocalInMeter: Double
    private var inFrontOfSubjectInMeter: Double
    private var behindSubjectInMeter: Double
    private let circleOfConfusionInMillimet: Double
    
    init(sensorType: String, focalLengthInMillimeter: Double, aperture: Double, distanceInMeter: Double) {
        self.sensorType = sensorType
        self.focalLengthInMillimeter = focalLengthInMillimeter
        self.aperture = aperture
        self.distanceInMeter = distanceInMeter
        
        switch sensorType {
        case selectionsOfSensorPicker[0]:
            self.circleOfConfusionInMillimet = 0.029
        case selectionsOfSensorPicker[1]:
            self.circleOfConfusionInMillimet = 0.0185
        case selectionsOfSensorPicker[2]:
            self.circleOfConfusionInMillimet = 0.015
        default:
            self.circleOfConfusionInMillimet = 0.02
        }
        
        self.hyperfocalInMeter = focalLengthInMillimeter + focalLengthInMillimeter * focalLengthInMillimeter / (aperture * circleOfConfusionInMillimet) / 1000
        self.nearDistanceInMeter = hyperfocalInMeter * distanceInMeter / (hyperfocalInMeter + distanceInMeter)
        self.farDistanceInMeter = hyperfocalInMeter * distanceInMeter / (hyperfocalInMeter - distanceInMeter)
        self.depthOfFieldInMeter = farDistanceInMeter - nearDistanceInMeter
        self.inFrontOfSubjectInMeter = depthOfFieldInMeter / 3
        self.behindSubjectInMeter = depthOfFieldInMeter * 2 / 3
    }
    
    func getDepthOfFieldInMeter() -> Double {
        return self.depthOfFieldInMeter
    }
    
    func getNearDistanceInMeter() -> Double {
        return self.nearDistanceInMeter
    }
    
    func getFarDistanceInMeter() -> Double {
        return self.farDistanceInMeter
    }
    
    func getHyperfocalDistanceInMeter() -> Double {
        return self.hyperfocalInMeter
    }
    
    func getInFrontSubjectInMeter() -> Double {
        return self.inFrontOfSubjectInMeter
    }
    
    func getBehindSubjectInMeter() -> Double {
        return self.behindSubjectInMeter
    }
}
