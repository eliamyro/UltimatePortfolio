//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Elias Myronidis on 7/5/22.
//

import XCTest
@testable import UltimatePortfolio

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformace() throws {
        // Create a significant amount of sample data
        for _ in 1 ... 100 {
            try dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the number of awards is constant. Change if you add new Awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
