//
//  ExtensionTests.swift
//  UltimatePortfolioTests
//
//  Created by Elias Myronidis on 6/5/22.
//

import SwiftUI
import XCTest
@testable import UltimatePortfolio

class ExtensionTests: XCTestCase {
    func testSequenceKeypathSortingSelf() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self)
        XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5], "The sorted numbers must be ascending")
    }

    func testSequenceKeypathSortingCustom() {
        let items = [1, 4, 3, 2, 5]
        let sortedItems = items.sorted(by: \.self, using: >)
        XCTAssertEqual(sortedItems, [5, 4, 3, 2, 1], "The sorted numbers must be descending")
    }

    func testBundleDecodable() {
        let allAwards = Bundle.main.decode([Award].self, from: "Awards.json")
        XCTAssertFalse(allAwards.isEmpty, "The awards should not be empty")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")
        XCTAssertEqual(data, "In Greece rains only for 2 months")
    }

    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")
        XCTAssertEqual(data.count, 3, "There should be 3 items decoded from DecodableDictionary.json")
        XCTAssertEqual(data["one"], 1, "The dictionary should contain Int to String mappings")
    }

    func testBindingOnChange() {
        // Given
        var onChangeFunctionRun = false

        func exampleFunctionToCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""

        let binding = Binding(
            get: { storedValue},
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunctionToCall)

        // When
        changedBinding.wrappedValue = "Test"

        // Then
        XCTAssertTrue(onChangeFunctionRun, "The onChange function should be called when binding has been changed.")
    }
}
