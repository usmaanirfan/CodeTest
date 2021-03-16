//
//  WeatherControllerTestSuite.swift
//  CodeTestTests
//
//  Created by Usman Ansari on 16/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import XCTest
@testable import CodeTest

class WeatherControllerTestSuite: XCTestCase {
    var weatherController: WeatherController?
    private var urlSessionMock: URLSessionMock!
    var networkRequest : NetworkClient!
    var expectation : XCTestExpectation?
    override func setUp() {
        urlSessionMock = URLSessionMock()
        networkRequest = NetworkClient(session: urlSessionMock)
    }

    override func tearDown() {

    }

    func testRefresh() {
        //Given
        weatherController = WeatherController(networkRequest: networkRequest)
        //When
        weatherController?.refresh()
        //Then
        XCTAssertEqual(self.weatherController?.locations.count ?? 0, 4, "testRefresh is not working")
    }

    func testAddLocation() {
        //Given
        weatherController = WeatherController(networkRequest: networkRequest)
        //When
        weatherController?.refresh()
        weatherController?.addLocation(locationName: "Delhi")
        //Then
        XCTAssertEqual(self.weatherController?.locations.count ?? 0, 5, "testAddLocation is not working")
    }

    func testDeleteLocation() {
        //Given
        weatherController = WeatherController(networkRequest: networkRequest)
        weatherController?.bind(view: self)
        weatherController?.refresh()
        //When
        weatherController?.deleteLocation(index: 3)
        self.expectation = XCTestExpectation(description: "Delegate method should fire")
        wait(for: [self.expectation!], timeout: 0.1)
        //Then
        XCTAssertEqual(self.weatherController?.locations.count ?? 0, 3, "testDeleteLocation is not working")
    }

    func testGetIndexOfItem() {
        //Given
        weatherController = WeatherController(networkRequest: networkRequest)
        weatherController?.refresh()

        //When
        let index = weatherController?.getIndexOfItem(locationId: "d6f9480b-d368-405b-8376-f983eb8477a7")

        XCTAssertEqual(index, 0, "testGetIndexOfItem is not working")

    }

}

extension WeatherControllerTestSuite : WeatherView {
    func showEntries() {

    }

    func displayError(error: Error) {

    }

    func appendEntry(at index: Int) {

    }

    func deleteEntry(at index: Int) {
        self.expectation?.fulfill()
    }

    func showLoading() {

    }

    func hideLoading() {
        
    }


}
