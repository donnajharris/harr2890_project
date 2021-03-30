//
//  AddItemVCTests.swift
//  harr2890_projectTests
//
//  Created by Donna Harris on 2021-03-24.
//

import XCTest
@testable import harr2890_project

class AddItemVCTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//    func tryIt() throws {
//        let addVC = AddItemViewController()
//        let listVC = ListItemViewController()
//
//        var tableView : UITableView
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        let date1 = formatter.date(from: "25/03/2021")
//        let itemToAdd = Item(title: "Item A", date: date1!, type: Item.ItemType.ON)
//
//        // Act
//
//        addVC.prepare(for: <#T##UIStoryboardSegue#>, sender: <#T##Any?#>)
//    }
    
    
    // MARK: - selectedSegmentControl Tests
    
    func test_setType_ONselected() {
        
        let addVC = AddItemViewController()
        let typeField = UISegmentedControl(items: ["on", "by"])
        typeField.selectedSegmentIndex = 0
        
        let expected : Item.ItemType = Item.ItemType.ON
        
        let actual : Item.ItemType
        
        actual = addVC.setType(typeField: typeField)
        
        
        XCTAssertEqual(expected, actual)

    }
    
    func test_setType_BYselected() {
        
        let addVC = AddItemViewController()
        let typeField = UISegmentedControl(items: ["on", "by"])
        typeField.selectedSegmentIndex = 1
        
        let expected : Item.ItemType = Item.ItemType.BY
        
        let actual : Item.ItemType
        
        actual = addVC.setType(typeField: typeField)
        
        
        XCTAssertEqual(expected, actual)

    }
    
    func test_setType_NoneSelected_defaultsToON() {
        
        let addVC = AddItemViewController()
        let typeField = UISegmentedControl(items: ["on", "by"])
        //typeField.selectedSegmentIndex = 3
        
        let expected : Item.ItemType = Item.ItemType.ON
        
        let actual : Item.ItemType
        
        actual = addVC.setType(typeField: typeField)
        
        
        XCTAssertEqual(expected, actual)

    }

}
