//
//  ChartDataTests.swift
//  TelegramChartsTests
//
//  Created by Konstantin Simakov on 12/03/2019.
//  Copyright © 2019 Konstantin Simakov (simakov.it). All rights reserved.
//

import XCTest

class ChartDataTests: XCTestCase {
    var chartData: ChartData!
    
    override func setUp() {
        let chartJson: [String: Any] = [
            "columns": [["x", 1542412800000], ["y0", 20, 30]],
            "types": ["x": "x", "y0": "line"],
            "names": ["x": "name1", "y0": "name2"],
            "colors": ["x": "#FFFFFF", "y0": "#000000"],
            ]
        chartData = ChartData(json: chartJson)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testColumnValues() {
        assert(chartData.columns["x"] != nil, "Column data should be filled")
        assert(chartData.columns["y0"] != nil, "Column data should be filled")
        assert(chartData.columns["x"]?.first == 1542412800000, "Column data is correct")
        assert(chartData.columns["y0"]?.count == 2)
        assert(chartData.columns["y0"]?.first == 20, "Column data is correct")
    }
    
    func testTypes() {
        assert(chartData.types["x"] == "x")
        assert(chartData.types["y0"] == "line")
    }
    
    func testNames() {
        assert(chartData.names["x"] == "name1")
        assert(chartData.names["y0"] == "name2")
    }
    
    func testColors() {
        assert(chartData.colors["x"] == "#FFFFFF")
        assert(chartData.colors["y0"] == "#000000")
    }
}
