//
//  WeatherViewControllerTestSuite.swift
//  CodeTestTests
//
//  Created by Usman Ansari on 16/03/21.
//  Copyright © 2021 Emmanuel Garnier. All rights reserved.
//

import XCTest

@testable import CodeTest

class WeatherViewControllerTestSuite: XCTestCase {
    var weatherViewController: WeatherViewController!
    private var urlSessionMock: URLSessionMock!
    override func setUp() {
        urlSessionMock = URLSessionMock()
        let networkRequest = NetworkClient(session: urlSessionMock)
        let controller = WeatherController(networkRequest: networkRequest)
        self.weatherViewController = WeatherViewController.create(controller: controller)
        _ = self.weatherViewController.view

    }

    // MARK: Nil Checks
    func testLibraryVC_TableViewShouldNotBeNil() {
        XCTAssertNotNil(self.weatherViewController.tableView)
    }

    func testCollectionDataSourceViewDataSource(){
        XCTAssertNotNil(self.weatherViewController.tableView.dataSource)
    }

    func testCollectionDataSourceViewDelegate() {
        XCTAssertNotNil(self.weatherViewController.tableView.delegate)
    }


    // MARK: Number of items Checks
    func testViewNumberOfSections() {
        XCTAssertEqual(self.weatherViewController.tableView.numberOfSections, 1)
    }

    func testViewNumberOfRows() {
        XCTAssertEqual(self.weatherViewController.tableView.numberOfRows(inSection: 0), 4)
    }

    // MARK: Cells
    func testCell_RowAtIndex_ReturnsPlaceCell() {
        self.weatherViewController.tableView.reloadData()
        let cellQueried = self.weatherViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cellQueried is LocationTableViewCell)
    }

    //Navigation Title
    func testCellNavigationTitle() {
        XCTAssertEqual(self.weatherViewController.title, AppConstants.ViewController.weatherViewTitle)
    }

}
