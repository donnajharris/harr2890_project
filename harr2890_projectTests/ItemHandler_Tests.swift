//
//  ItemHandler_Tests.swift
//  harr2890_projectTests
//
//  Created by Donna Harris on 2021-04-16.
//

import XCTest
@testable import harr2890_project

class ItemHandler_Tests: XCTestCase {

    func test_sortDataByDate_chronologicalOrder() {
        
        // arrange
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")
                
        var items = [Item]()
        items.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        items.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        items.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))

        var expectedItems = [Item]()
        expectedItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))

        
        // act
        let db = try! MockedDatabaseAccess()
        let itemHandler = ItemHandler(dal: db)
        itemHandler.sortDataByDate(data: &items)
        
        
        // assert
        XCTAssertEqual(expectedItems, items)
    }
    
    
    func test_getItemsFromDB_returnsAllItems() throws {
        
        // arrange
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")
        
        var actualItems = [Item]()  // start empty

        var expectedItems = [Item]()
        expectedItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))

        let db = try! MockedDatabaseAccess()
        let itemHandler = ItemHandler(dal: db)

        // act
        try itemHandler.getItemsFromDB(tableData: &actualItems)

        // assert
        XCTAssertEqual(expectedItems, actualItems)
    }
    

    func test_addItemToDB_returnsUpdatedItemList() throws {

        // arrange
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")
                
        var actualItems = [Item]()
        actualItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        actualItems.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        actualItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))

        
        let date4 = formatter.date(from: "28/03/2021") // second date
        let itemToAdd = Item(id: Int64(4), title: "Newly Added Item", date: date4!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false)
        
        
        var expectedItems = [Item]()
        expectedItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(itemToAdd)
        expectedItems.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        
        
        let db = try! MockedDatabaseAccess()
        let itemHandler = ItemHandler(dal: db)

        // act
        try itemHandler.addItemToDB(item: itemToAdd, tableData: &actualItems)

        // assert
        XCTAssertEqual(expectedItems, actualItems)
    }
    
    
    func test_removeItemFromDB_returnsUpdatedItemList() throws {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")
        let date4 = formatter.date(from: "27/03/2021")

                
        let itemToRemove = Item(id: Int64(4), title: "Item to Remove", date: date4!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false)

        let actualIndex = 1  //  2nd item in the table list (index 1)

        var actualItems = [Item]()
        actualItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        actualItems.append(itemToRemove)
        actualItems.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        actualItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))

        
        var expectedItems = [Item]()
        expectedItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        
        
        let db = try! MockedDatabaseAccess()
        let itemHandler = ItemHandler(dal: db)

        // act
        try itemHandler.removeItemFromDB(indexToDelete: actualIndex, item: itemToRemove, tableData: &actualItems)

        // assert
        XCTAssertEqual(expectedItems, actualItems)
    }
    
    
    func test_updateItemInDB_returnsUpdatedItemInList() throws {

        // arrange
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2022")
        let date3 = formatter.date(from: "02/01/2023")
        
        let date4 = formatter.date(from: "28/04/2020") // makes it the oldest
        
        var actualItems = [Item]()
        actualItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        actualItems.append(Item(id: Int64(2), title: "Item To Edit", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        actualItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))


        let updateItemWith = Item(id: Int64(2), title: "Edited Item", date: date4!, type: Item.ItemType.BY, category: CategoryHelper.UNCATEGORIZED, changed: true)


        var expectedItems = [Item]()
        expectedItems.append(Item(id: Int64(2), title: "Edited Item", date: date4!, type: Item.ItemType.BY, category: CategoryHelper.UNCATEGORIZED, changed: false)) // gets reset to FALSE
        expectedItems.append(Item(id: Int64(3), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        expectedItems.append(Item(id: Int64(1), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))

        
        let db = try! MockedDatabaseAccess()
        let itemHandler = ItemHandler(dal: db)

        // act
        try itemHandler.updateItemInDB(item: updateItemWith, tableData: &actualItems)

        // assert
        XCTAssertEqual(expectedItems, actualItems)
        
    }

}
