//
//  MarvelCharacters_iOSAppUITests.swift
//  MarvelCharacters-iOSAppUITests
//
//  Created by Sergio Martínez Muñoz on 26/7/21.
//

import XCTest

class MarvelCharacters_UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }

    func testNavigateToCharacterDetail() throws {
        // GIVEN - App loads
        let app = XCUIApplication()
        app.launch()

        // WHEN - User taps on any cell
        let randomIndex = Int.random(in: 0...4)
        let cell = app.tables.cells.element(boundBy: randomIndex)
        let cellName = cell.staticTexts.firstMatch.label
        cell.tap()

        // THEN - We are in the detail screen for the character
        XCTAssertTrue(app.navigationBars.staticTexts[cellName].exists, "Test failed - No character name in navigation bar matching character tapped at character list screen")
        let titleLabel = app.scrollViews.staticTexts["characterName"]
        XCTAssert(titleLabel.label == cellName, "Test failed - Character name not matching character tapped at the character list screen")
    }

    func testSearchUsingSearchBar() throws {
        // GIVEN - App loads
        let app = XCUIApplication()
        app.launch()

        // WHEN - User writes some characters in the search bar
        app.searchFields.firstMatch.tap()
        let searchQuery = "Spi"
        app.searchFields.firstMatch.typeText(searchQuery)
        //Wait for the search to complete
        sleep(3)

        // THEN - the new list features only characters beginning by the string entered by the user
        for name in app.tables.cells.staticTexts.allElementsBoundByIndex {
            let characterPrefix = String(name.label.prefix(searchQuery.count))
            XCTAssertTrue(characterPrefix == searchQuery, "Test failed - a character does not match the search query: \(name.label), search query: \(searchQuery)")
            // Seems necessary -why?
            sleep(1)
        }
    }
}
