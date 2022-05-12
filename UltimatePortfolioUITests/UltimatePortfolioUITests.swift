//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Elias Myronidis on 7/5/22.
//

import XCTest

class UltimatePortfolioUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas4Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }

    func testOpenTabAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1 ... 5 {
            app.buttons["Add Project"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) no list row(s).")
        }
    }

    func testAddingItemInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Project"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

        for tapCount in 1 ... 3 {
            app.buttons["Add Item"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount + 1, "There should be \(tapCount) list rows.")
        }
    }

    // Cant make it work TODO: Fix it
//    func testEditingProjectUpdatesCorrectly() {
//        app.buttons["Open"].tap()
//        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")
//
//        app.buttons["Add Project"].tap()
//        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")
//
//        app.buttons["NEW PROJECT"].tap()
//        app.textFields["New Project"].tap()
//
//        app.keys["space"].tap()
//        app.keys["more"].tap()
//        app.keys["2"].tap()
//        app.keys["Return"].tap()
//
//        app.buttons["Open Projects"].tap()
//        XCTAssertTrue(app.buttons["NEW PROJECT 2"].exists, "There should be a project with name 'Project 2'")
//    }

    func testEditingItemUpdatesCorrectly() {
        testAddingItemInsertsRows()

        app.buttons["New Item"].firstMatch.tap()
        app.textFields["New Item"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()

        app.buttons["Open Projects"].tap()
        XCTAssertTrue(app.buttons["New Item 2"].exists, "There should be a project with name 'Project 2'")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a locked alert showing for awards.")
        }
    }
}
