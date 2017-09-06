//
//  PhotographyParameter.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/09/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import Foundation

class PhotographyParameter {
    private let sensorType: String
    private let focalLengthInMillimeter: Float
    private let aperture: Float
    private let distanceInMeter: Float
    
    private let depthOfFieldInMeter: Float
    private let nearDistanceInMeter: Float
    private let farDistanceInMeter: Float
    private let hyperfocalInMeter: Float
    private let inFrontOfSubjectInMeter: Float
    private let behindSubjectInMeter: Float
    private let circleOfConfusionInMillimet: Float
    
    init(sensorType: String, focalLengthInMillimeter: Float, aperture: Float, distanceInMeter: Float) {
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
    
    func getDepthOfFieldInMeter() -> Float {
        return self.depthOfFieldInMeter
    }
    
    func getNearDistanceInMeter() -> Float {
        return self.nearDistanceInMeter
    }
    
    func getFarDistanceInMeter() -> Float {
        return self.farDistanceInMeter
    }
    
    func getHyperfocalDistanceInMeter() -> Float {
        return self.hyperfocalInMeter
    }
    
    func getInFrontSubjectInMeter() -> Float {
        return self.inFrontOfSubjectInMeter
    }
    
    func getBehindSubjectInMeter() -> Float {
        return self.behindSubjectInMeter
    }
}
