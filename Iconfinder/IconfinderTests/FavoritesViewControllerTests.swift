//
//  FavoritesViewControllerTests.swift
//  IconfinderTests
//
//  Created by Aleksandr Fetisov on 26.06.2024.
//

import XCTest
@testable import Iconfinder

class FavoritesViewControllerTests: XCTestCase {

    var presenterMock: FavoritesPresenterMock!
    var viewController: FavoritesViewController!

    override func setUpWithError() throws {
        presenterMock = .init()
        viewController = FavoritesViewController()
        viewController.presenter = presenterMock
    }

    override func tearDownWithError() throws {
        presenterMock = nil
        viewController = nil
    }

    func testThatGetDataCalls() {
        // arrange
        presenterMock.getDataWasCalled = false

        // act
        viewController.viewDidLoad()

        // assert
        XCTAssertTrue(presenterMock.getDataWasCalled)
    }

    func testThatNavigationItemSelectorCallsRemoveAll() {
        // arrange
        presenterMock.removeAllWasCalled = false

        // act
        viewController.removeAll()

        // assert
        XCTAssertTrue(presenterMock.removeAllWasCalled)
    }

}
