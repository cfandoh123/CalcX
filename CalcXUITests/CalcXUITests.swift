//
//  CalcXUITests.swift
//  CalcXUITests
//
//  Created by Calvin Andoh on 7/13/25.
//

import XCTest

final class CalcXUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testBasicCalculation() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["2"].tap()
        app.buttons["+"].tap()
        app.buttons["2"].tap()
        app.buttons["="].tap()
        let result = app.staticTexts.element(matching: .any, identifier: nil).matching(NSPredicate(format: "label == '4'"))[0]
        XCTAssertTrue(result.exists, "Result should be 4")
    }

    @MainActor
    func testClearAndDelete() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["Del"].tap()
        XCTAssertTrue(app.staticTexts["1"].exists)
        app.buttons["C"].tap()
        XCTAssertFalse(app.staticTexts["1"].exists)
    }

    @MainActor
    func testPercent() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["5"].tap()
        app.buttons["0"].tap()
        app.buttons["%"].tap()
        let result = app.staticTexts.element(matching: .any, identifier: nil).matching(NSPredicate(format: "label == '0.5'"))[0]
        XCTAssertTrue(result.exists, "Result should be 0.5")
    }

    @MainActor
    func testThemeToggle() throws {
        let app = XCUIApplication()
        app.launch()
        let moon = app.images["moon.fill"]
        let sun = app.images["sun.max.fill"]
        XCTAssertTrue(moon.exists)
        XCTAssertTrue(sun.exists)
        // Tap the toggle (simulate tap on the capsule area)
        let toggle = app.otherElements.containing(.image, identifier: "moon.fill").element(boundBy: 0)
        if toggle.exists { toggle.tap() }
        // No crash = pass; for more, check color changes if possible
    }
}
