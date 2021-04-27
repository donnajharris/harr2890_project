//
//  Mock_DBAccess.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-07.
//

import Foundation


class MockedDatabaseAccess : DatabaseAccess {
    
    required init() throws {

    } // init
    
    
    // MARK: - Item operations
    
    func insertItem(item: Item) throws -> Int64 {
        return Int64(4)  // value that matches with Happy Path test, the returned ID of new row
    } // insertItem
    
    
    func updateItem(item: Item, rowId: Int64) throws -> Int {
        return Int(1)  // value that matches with Happy Path test: 1 updated row
    } // updateItem

    
    func getAllItems() throws -> [Item] {
        var items = [Item]()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")
        
        items.append(Item(id: Int64(3), title: "Third Item", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        items.append(Item(id: Int64(2), title: "Second Item", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        items.append(Item(id: Int64(1), title: "First Item", date: date1!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false))
        
        return items  // returns data that needs to be sorted chronologically still
        
    } // getAllItems
    
    
    func getAllItemsWithLocations(daysFilter: Int) throws -> [Item] {
        // NOT YET IMPLEMENTED FOR TESTING
        return [Item]()
    }
    
    
    func getItemsInCategory(categoryId: Int64) throws -> [Item] {
        // NOT YET IMPLEMENTED FOR TESTING
        return [Item]()
    }
    
    
    func removeItem(rowId: Int64) throws -> Int {
        return Int(1)  // value that matches with Happy Path test: 1 deleted row
    } // removeItem
    
    
    // MARK: - Category operations
    
    func getAllCategories() throws -> [ItemCategory] {
        
        // This data is designed to be in ID order, but NOT in alphabetical order
        var categoriesInIdOrder = [ItemCategory]()
        categoriesInIdOrder.append(ItemCategory(id: Int64(1), name: "Second Category"))
        categoriesInIdOrder.append(ItemCategory(id: Int64(2), name: "Third Category"))
        categoriesInIdOrder.append(ItemCategory(id: Int64(3), name: "First Category"))
        
        return categoriesInIdOrder
    }
    
    func getCategory(id: Int64) throws -> ItemCategory {
        return ItemCategory(id: Int64(1), name: "First Category")
    }
    
    func insertCategory(category: ItemCategory) throws -> Int64 {
        return Int64(4)  // value that matches with Happy Path test, the returned ID of new row
    }
    
    func updateCategory(category: ItemCategory, rowId: Int64) throws -> Int {
        return Int(1)  // value that matches with Happy Path test: 1 updated row
    }
    
    func removeCategory(rowId: Int64) throws -> Int {
        return Int(1)  // value that matches with Happy Path test: 1 deleted row
    }
    
}

