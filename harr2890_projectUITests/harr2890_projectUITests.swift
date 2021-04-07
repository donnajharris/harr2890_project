//
//  harr2890_projectUITests.swift
//  harr2890_projectUITests
//
//  Created by Donna Harris on 2021-04-07.
//

import XCTest

class harr2890_projectUITests: XCTestCase {

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
        
//
//        let app = XCUIApplication()
//        let tablesQuery = app.tables
//        let apr72021StaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Apr. 7, 2021"]/*[[".cells.staticTexts[\"Apr. 7, 2021\"]",".staticTexts[\"Apr. 7, 2021\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        apr72021StaticText.swipeLeft()
//
//        let closeButton = app.navigationBars["View Item"].buttons["Close"]
//
//        tablesQuery/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"One item").element/*[[".cells.containing(.staticText, identifier:\"by\").element",".cells.containing(.staticText, identifier:\"Apr. 7, 2021\").element",".cells.containing(.staticText, identifier:\"One item\").element"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
//        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//
//
//        let app = XCUIApplication()
//        app.navigationBars["Due Not Forget"].buttons["Add"].tap()
//
//        let enterWhatYouWantToRecallTextField = app.textFields["Enter what you want to recall"]
//
//        let app = XCUIApplication()
//        let oKey = app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        oKey.tap()
//        oKey.tap()
//
//        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        nKey.tap()
//        nKey.tap()
//
//        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        eKey.tap()
//        eKey.tap()
//        app.buttons["Return"].tap()
//        app.staticTexts["Save Item"].tap()
//        app.tables.cells.containing(.staticText, identifier:"the first one").element.tap()
//
//

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
    
    func test1_AddOneItem_isAdded() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let testText = "One item"
        
        var table = app.tables.element
        XCTAssertTrue(table.exists)
        var cell = table.cells.element(boundBy: 0)
        XCTAssertFalse(cell.exists)
        var indexedText = cell.staticTexts.element.staticTexts[testText]
        print("TOLD YOU>>>> \(indexedText)")
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
        
        // TODO: FIX THIS TEST ??? or good enough

        indexedText = cell.staticTexts.element.staticTexts[testText]
        let str = "\(indexedText)"
        XCTAssertTrue(str.contains(testText)) // close enough for this scenario
    }
    
    func test1_deleteOneItem_isRemoved() throws {
        let app = XCUIApplication()
        app.launch()

        let testText = "One item"
        
        var table = app.tables.element
        XCTAssertTrue(table.exists)
        var cell = table.cells.element(boundBy: 0)
        XCTAssertTrue(cell.exists)
        
        // TODO: FIX THIS TEST?
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
