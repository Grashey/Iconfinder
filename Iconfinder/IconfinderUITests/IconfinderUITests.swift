
//
//  IconfinderUITests.swift
//  IconfinderUITests
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import XCTest

final class IconfinderUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testThatSearchTextFieldCallsKeyboard() throws {
        // arrange
       let searchTextField = app.navigationBars["Поиск"].searchFields["Введите запрос..."]
       let key1 = app.keys["r"]
       let key2 = app.keys["e"]
       let key3 = app.keys["d"]
       let searchButton = app.keyboards.buttons["Search"]
                                       
        // act
        if searchTextField.isSelected {
            XCTAssertTrue(key1.exists)
            XCTAssertTrue(key2.exists)
            XCTAssertTrue(key3.exists)
            XCTAssertFalse(searchButton.isEnabled)
            
            key1.tap()
            key2.tap()
            key3.tap()
            XCTAssertTrue(searchButton.isEnabled)
            searchButton.tap()
            XCTAssertFalse(searchButton.exists)
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
