//
//  CRUD_Tests.swift
//  harr2890_projectTests
//
//  Created by Donna Harris on 2021-04-07.
//

import XCTest
@testable import harr2890_project

class CRUD_Tests: XCTestCase {

    // MARK: - List View Tests
    
    func test_ListView_3itemsToLoad_() {
        
        // arrange
        var items = [Item]()
        let vc = ListViewController()
        let expected = 3

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")  // 1
        let date2 = formatter.date(from: "22/09/2021")  // 2
        let date3 = formatter.date(from: "02/01/2022")  // 3


        let item1 = Item(title: "[1] Credit card expires", date: date2!, type: Item.ItemType.ON, changed: false)
        items.append(item1)
        
        let item2 = Item(title: "[2] Use roast beef", date: date1!, type: Item.ItemType.BY, changed: false)
        items.append(item2)
        
        let item3 = Item(title: "[3] Passport expires", date: date3!, type: Item.ItemType.ON, changed: false)
        items.append(item3)
        
        vc.setTableData(items: items)
        
        // act
        
        let actual = vc.tableView(vc.myTableView, numberOfRowsInSection: 0)
        
        // assert
        XCTAssertEqual(expected, actual)

    }

}
