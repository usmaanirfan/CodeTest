//
//  AppConstants.swift
//  CodeTest
//
//  Created by Usman Ansari on 16/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import Foundation
struct AppConstants {
    struct SpinnerValues {
        static let rotationFromValue           = 0.0
        static let rotationToValue : Float   = Float(Double.pi * 2.0)
        static let rotationDuration            = 2.25
        static let cornerRadius : Float      = 4
    }
    struct ViewController {
        static let kSpinnerViewController       = "SpinnerViewController"
        static let weatherPickerData : [(String,String)] = [("CLOUDY","Cloudy"), ("SUNNY","Sunny"), ("MOSTLY_SUNNY","Mostly sunny"), ("PARTLY_SUNNY_RAIN", "Partly sunny rain"), ("THUNDER_CLOUD_AND_RAIN", "Thunder cloud rain"), ("TORNADO","Tornado"),("BARELY_SUNNY","Barely sunny"),("LIGHTENING", "Lightening"),("SNOW_CLOUD","Snow cloud"),("RAINY","Rainy"),("PARTLY_SUNNY", "Partly sunny")]
        static let weatherDetailTitle = "Weather detail"
        static let weatherViewTitle = "Weather Code Test"
    }
}
