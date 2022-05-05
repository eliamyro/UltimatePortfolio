//
//  AssetTests.swift
//  UltimatePortfolioTests
//
//  Created by Elias Myronidis on 4/5/22.
//

import XCTest
@testable import UltimatePortfolio

class AssetTests: XCTestCase {

    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color \(color) from asset catalog.")
        }
    }

    func testAwardsJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load Awards from JSON.")
    }
}
