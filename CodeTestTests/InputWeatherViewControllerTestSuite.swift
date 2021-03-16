//
//  InputWeatherViewControllerTestSuite.swift
//  CodeTestTests
//
//  Created by Usman Ansari on 17/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import XCTest

@testable import CodeTest

class InputWeatherViewControllerTestSuite: XCTestCase {
    var inputWeatherViewController: InputWeatherViewController!
    override func setUp() {
        self.inputWeatherViewController = InputWeatherViewController.create()
        _ = self.inputWeatherViewController.view

    }

    // MARK: Nil Checks
    func testTextFieldWeatherShouldNotBeNil() {
        XCTAssertNotNil(self.inputWeatherViewController.theTextfieldWeather)
    }
    func testTextFieldLocationShouldNotBeNil() {
        XCTAssertNotNil(self.inputWeatherViewController.theTextfieldLocation)
    }
    func testTextFieldTempratureShouldNotBeNil() {
        XCTAssertNotNil(self.inputWeatherViewController.theTextfieldTemprature)
    }

    //Navigation Title
    func testCellNavigationTitle() {
        XCTAssertEqual(self.inputWeatherViewController.title, AppConstants.ViewController.weatherDetailTitle)
    }

}
