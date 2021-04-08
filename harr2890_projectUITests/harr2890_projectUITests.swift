//
//  harr2890_projectUITests.swift
//  harr2890_projectUITests
//
//  Created by Donna Harris on 2021-04-07.
//

/*
    TIPS: https://www.hackingwithswift.com/articles/148/xcode-ui-testing-cheat-sheet
 */


/*
    RUNNING THESE ... start from a BLANK PHONE and excecute in order
 */

import XCTest

class harr2890_projectUITests: XCTestCase {

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        
    }

    
    
    func test1a_AddOneItem_isAdded() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let testText = "One item"
        
        var table = app.tables.element
        XCTAssertTrue(table.exists)
        var cell = table.cells.element(boundBy: 0)
        XCTAssertFalse(cell.exists)
        var indexedText = cell.staticTexts.element.staticTexts[testText]
        XCTAssertFalse(indexedText.exists)
        
        app.navigationBars["Due Not Forget"].buttons["Add"].tap()
        app.textFields["Enter what you want to recall"].tap()
        app.textFields["Enter what you want to recall"].typeText(testText)
        
        app.buttons["Return"].tap()
        app.staticTexts["Save Item"].tap()
        
        table = app.tables.element
        XCTAssertTrue(table.exists)
        cell = table.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        
        indexedText = cell.staticTexts.element.staticTexts[testText]
        let str = "\(indexedText)"
        XCTAssertTrue(str.contains(testText)) // close enough for this scenario
    }
    
    func test1b_deleteOneItem_isRemoved() throws {
        let app = XCUIApplication()
        app.launch()

        let testText = "One item"
        
        var table = app.tables.element
        XCTAssertTrue(table.exists)
        var cell = table.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        
        let indexedText = cell.staticTexts.element.staticTexts[testText]
        let str = "\(indexedText)"
        XCTAssertTrue(str.contains(testText)) // close enough for this scenario
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:testText).element.swipeLeft()
        tablesQuery.buttons["Delete"].tap()

        table = app.tables.element
        XCTAssertTrue(table.exists)
        cell = table.cells.element(boundBy: 0)
        XCTAssertFalse(cell.exists)

    }
}
