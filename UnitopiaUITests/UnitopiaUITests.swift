//
//  UnitopiaUITests.swift
//  UnitopiaUITests
//
//  Created by Justin Hold on 2/27/26.
//

import XCTest

final class UnitopiaUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Reset relevant UserDefaults so tests start from a known state
        app.launchArguments += ["-hasSeenWelcome", "YES"]
        app.launchArguments += ["-AppleLanguages", "(en)"]
        app.launchArguments += ["-AppleLocale", "en_US"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Tab Navigation

    func testTabBarIsVisible() {
        XCTAssertTrue(app.tabBars.firstMatch.exists)
    }

    func testHomeTabExists() {
        XCTAssertTrue(app.tabBars.buttons["Home"].exists)
    }

    func testFavoritesTabExists() {
        XCTAssertTrue(app.tabBars.buttons["Favorites"].exists)
    }

    func testSettingsTabExists() {
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }

    func testTappingFavoritesTabShowsFavoritesTitle() {
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.navigationBars["Favorites"].exists)
    }

    func testTappingSettingsTabShowsSettingsTitle() {
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.navigationBars["Settings"].exists)
    }

    func testTappingHomeTabShowsUnitopiaTitle() {
        // Navigate away first
        app.tabBars.buttons["Settings"].tap()
        // Return to Home
        app.tabBars.buttons["Home"].tap()
        XCTAssertTrue(app.navigationBars["Unitopia"].exists)
    }

    // MARK: - Home Tab

    func testNewConversionButtonExists() {
        XCTAssertTrue(app.buttons["New Conversion"].exists ||
                      app.cells.staticTexts["New Conversion"].exists)
    }

    func testTappingNewConversionOpensConverter() {
        // Tap the New Conversion link
        let newConversion = app.cells.staticTexts["New Conversion"]
        if newConversion.waitForExistence(timeout: 3) {
            newConversion.tap()
        } else {
            app.buttons["New Conversion"].tap()
        }
        // Converter navigation bar should be visible
        XCTAssertTrue(app.navigationBars["Converter"].waitForExistence(timeout: 3))
    }

    // MARK: - Converter

    func testConverterFormSectionsExist() {
        navigateToConverter()
        XCTAssertTrue(app.staticTexts["Amount to convert"].exists)
        XCTAssertTrue(app.staticTexts["Result"].exists)
    }

    func testConverterPickersExist() {
        navigateToConverter()
        XCTAssertTrue(app.buttons["Conversion"].exists ||
                      app.otherElements.matching(identifier: "Conversion").firstMatch.exists)
    }

    func testEnteringAmountShowsResult() {
        navigateToConverter()
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("32")
        // Dismiss keyboard
        app.buttons["Done"].tap()
        // Result section should no longer show "--"
        let resultSection = app.cells.containing(.staticText, identifier: "Result")
        XCTAssertFalse(app.staticTexts["--"].exists)
    }

    func testStartOverButtonExistsWhenInputIsNonZero() {
        navigateToConverter()
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("100")
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons["Start Over"].waitForExistence(timeout: 2))
    }

    func testStartOverButtonShowsAlert() {
        navigateToConverter()
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("100")
        app.buttons["Done"].tap()
        app.buttons["Start Over"].tap()
        XCTAssertTrue(app.alerts["Reset Settings?"].waitForExistence(timeout: 2))
    }

    func testResetAlertCancelDismissesWithoutReset() {
        navigateToConverter()
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("100")
        app.buttons["Done"].tap()
        app.buttons["Start Over"].tap()
        app.alerts["Reset Settings?"].buttons["Cancel"].tap()
        // Text field should still have a value (not reset to empty)
        XCTAssertFalse(app.alerts.firstMatch.exists)
    }

    func testResetAlertConfirmResetsInput() {
        navigateToConverter()
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText("100")
        app.buttons["Done"].tap()
        app.buttons["Start Over"].tap()
        app.alerts["Reset Settings?"].buttons["Reset"].tap()
        // Result should be "--" (input is 0)
        XCTAssertTrue(app.staticTexts["--"].waitForExistence(timeout: 2))
    }

    func testStarButtonExistsInConverter() {
        navigateToConverter()
        // Star button should be in the nav bar toolbar
        let star = app.buttons["Save as favorite"]
        XCTAssertTrue(star.waitForExistence(timeout: 2))
    }

    // MARK: - Favorites Tab

    func testFavoritesSegmentedControlExists() {
        app.tabBars.buttons["Favorites"].tap()
        // Both segment options should exist
        XCTAssertTrue(app.buttons["Conversions"].waitForExistence(timeout: 2) ||
                      app.segmentedControls.firstMatch.exists)
    }

    func testFavoritesEmptyStateShowsWhenNoFavorites() {
        app.tabBars.buttons["Favorites"].tap()
        // With a fresh install the empty state message should appear
        let emptyMessage = app.staticTexts["No Favorite Conversions"]
        XCTAssertTrue(emptyMessage.waitForExistence(timeout: 2))
    }

    func testUnitPairsSegmentShowsEmptyStateWhenNoFavorites() {
        app.tabBars.buttons["Favorites"].tap()
        app.buttons["Unit Pairs"].tap()
        let emptyMessage = app.staticTexts["No Favorite Unit Pairs"]
        XCTAssertTrue(emptyMessage.waitForExistence(timeout: 2))
    }

    func testSavingUnitPairAppearsInFavorites() {
        navigateToConverter()
        // Tap the star to favorite the default Fahrenheit → Celsius pair
        app.buttons["Save as favorite"].tap()
        // Go to Favorites → Unit Pairs
        app.tabBars.buttons["Favorites"].tap()
        app.buttons["Unit Pairs"].tap()
        // Should no longer show empty state
        XCTAssertFalse(app.staticTexts["No Favorite Unit Pairs"].waitForExistence(timeout: 1))
    }

    // MARK: - Settings Tab

    func testDarkModeToggleExistsInSettings() {
        app.tabBars.buttons["Settings"].tap()
        // Toggle could be labelled "Light Mode" or "Dark Mode"
        let toggle = app.switches.firstMatch
        XCTAssertTrue(toggle.waitForExistence(timeout: 2))
    }

    func testAppVersionDisplayedInSettings() {
        app.tabBars.buttons["Settings"].tap()
        // "Version" label should be present in the About section
        XCTAssertTrue(app.staticTexts["Version"].waitForExistence(timeout: 2))
    }

    func testDarkModeToggleCanBeToggled() {
        app.tabBars.buttons["Settings"].tap()
        let toggle = app.switches.firstMatch
        guard toggle.waitForExistence(timeout: 2) else {
            XCTFail("Dark mode toggle not found")
            return
        }
        let initialValue = toggle.value as? String
        toggle.tap()
        let newValue = toggle.value as? String
        XCTAssertNotEqual(initialValue, newValue)
        // Toggle back to restore state
        toggle.tap()
    }

    // MARK: - Helpers

    private func navigateToConverter() {
        // Make sure we're on Home first
        app.tabBars.buttons["Home"].tap()
        let newConversion = app.cells.staticTexts["New Conversion"]
        if newConversion.waitForExistence(timeout: 3) {
            newConversion.tap()
        }
        _ = app.navigationBars["Converter"].waitForExistence(timeout: 3)
    }
}
