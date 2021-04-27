//
//  ImplementedDatabaseAccess.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-30.
//

import Foundation
import SQLite

class ImplementedDatabaseAccess : DatabaseAccess {
    
    private var database : Connection? = nil
    private let DB_STRING = "DueNotForgetDB.plist"

    private var firstRun = false
    
    private var path : String {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url:String?
        url = urls.first?.appendingPathComponent(DB_STRING).path
        return url!
    }
    
    
    // Items table
    let itemsTable = Table("items")
    let itemId = Expression<Int64>("id")
    let itemTitle = Expression<String>("title")
    let itemType = Expression<String>("type")
    let itemDate = Expression<Date?>("date")
    let itemCategoryId = Expression<Int64>("categoryId")
    let itemLatitude = Expression<Double>("latitude")
    let itemLongitude = Expression<Double>("longitude")
    
    // Categories table
    let categoriesTable = Table("categories")
    let categoryId = Expression<Int64>("id")
    let categoryName = Expression<String>("name")
    
    
    required init() throws {
        
        // should fail immediately if it doesn't work
        
        do {
            database = try Connection(path)
            determineFirstRunStatus()
            initItemsTable()
            try initCategoriesTable()
            
        } catch {
            print("Unexpected error: \(error)")
        }

        
    } // init
    
    private func isFirstRun() -> Bool {
        return firstRun
    }
    
    private func determineFirstRunStatus() {
        
        do {
            _ = try getAllCategories()
        } catch {
            firstRun = true
        }
        
    }
    

//    private func dataFilePath() -> String {
//        let urls = FileManager.default.urls(for:
//            .documentDirectory, in: .userDomainMask)
//        var url:String?
//        url = urls.first?.appendingPathComponent(DB_STRING).path
//        return url!
//
//    } // dataFilePath
//
    
    private func initItemsTable() {
        
        if isFirstRun() {
            do {
                try database?.run(itemsTable.create(ifNotExists: true) { t in
                    t.column(itemId, primaryKey: .autoincrement)
                    t.column(itemTitle)
                    t.column(itemType)
                    t.column(itemDate)
                    t.column(itemCategoryId)
                    t.column(itemLatitude)
                    t.column(itemLongitude)
                })
            } catch {
                // real problem
                print("Unexpected error: \(error)")
            }
        }

    } // initItemsTable
    
    
    private func initCategoriesTable() throws {

        if isFirstRun() {
            do {
                try database?.run(categoriesTable.create(ifNotExists: true) {
                    t in
                    t.column(categoryId, primaryKey: .autoincrement)
                    t.column(categoryName)
                })
                
                // Add Uncategorized
                let result = try insertCategory(category: CategoryHelper.UNCATEGORIZED)

                if result != 1 {
                    print("Unexpected error: \(result) but should have been 1")
                }

               
            } catch {
                // real problem
                print("Unexpected error: \(error)")
            }
        }


    } // initCategoriesTable
    
    
    
    // MARK: - Item operations
    
    func insertItem(item: Item) throws -> Int64 {
        
        let helper = ItemHelper()

        let insert = itemsTable.insert(
                itemTitle <- item.getTitle(),
                itemType <- helper.getTypeString(item: item),
                itemDate <- item.getDate(),
                itemCategoryId <- Int64(item.getCategory()!.getId()!),
                itemLatitude <- Double(item.getLatitude()),
                itemLongitude <- Double(item.getLongitude())
        )
        
        let itemId = try! database?.run(insert)
        return itemId!
        
    } // insertItem
    
    
    func updateItem(item: Item, rowId: Int64) throws -> Int {
        
        let helper = ItemHelper()

        let filteredTable : Table = itemsTable.filter(itemId == rowId)

        let update = filteredTable.update(
            itemTitle <- item.getTitle(),
            itemType <- helper.getTypeString(item: item),
            itemDate <- item.getDate()
        )
        
        let numberOfUpdatedRows = try! database?.run(update)
        
        return numberOfUpdatedRows!
    } // updateItem

    
    func getAllItems() throws -> [Item] {
        
        let helper = ItemHelper()

        var items = [Item]()
        
        for itemRow in try! database!.prepare(itemsTable) {

            //print(itemRow)
            
            let category = try! getCategory(id: itemRow[itemCategoryId])
            
            let item = Item(id: itemRow[itemId],
                            title: itemRow[itemTitle],
                            date: itemRow[itemDate]!,
                            type: helper.translateToItemType(string: itemRow[itemType])!,
                            category: category,
                            changed: false,
                            latitude: itemRow[itemLatitude],
                            longitude: itemRow[itemLongitude])
            
            items.append(item)
        }
        
        return items
        
    } // getAllItems
    
    
    func getAllItemsWithLocations() throws -> [Item] {
        
        let helper = ItemHelper()

        var itemsWithLocations = [Item]()
        
        let filteredTable : Table = itemsTable.filter(  itemLatitude != Double(Item.UNDEFINED) &&
                                                        itemLongitude != Double(Item.UNDEFINED))

        for itemRow in try! database!.prepare(filteredTable) {

            print(itemRow)
            
            let category = try! getCategory(id: itemRow[itemCategoryId])
            
            let item = Item(id: itemRow[itemId],
                            title: itemRow[itemTitle],
                            date: itemRow[itemDate]!,
                            type: helper.translateToItemType(string: itemRow[itemType])!,
                            category: category,
                            changed: false,
                            latitude: itemRow[itemLatitude],
                            longitude: itemRow[itemLongitude])
            
            itemsWithLocations.append(item)
        }
        
        return itemsWithLocations
        
    }
    
    
    func removeItem(rowId: Int64) throws -> Int {
        
        let filteredTable : Table = itemsTable.filter(itemId == rowId)
        let numberOfDeletedRows = try! database?.run(filteredTable.delete())
        return numberOfDeletedRows!
        
    } // removeItem
    
    
    
    // MARK: - Category operations
    
    func getAllCategories() throws -> [ItemCategory] {
        
        var categories = [ItemCategory]()
        
        for categoryRow in try database!.prepare(categoriesTable) {
            
            let category = ItemCategory(id: categoryRow[categoryId],
                                        name: categoryRow[categoryName]
            )
            
            categories.append(category)
        }
    
        return categories
    }
    
    
    func getCategory(id: Int64) throws -> ItemCategory {
        
        var categories = [ItemCategory]()
        
        let filteredTable : Table = categoriesTable.filter(categoryId == id)
        
        for categoryRow in try! database!.prepare(filteredTable)
        {
            let category = ItemCategory(id: categoryRow[categoryId],
                                        name: categoryRow[categoryName]
            )
            
            categories.append(category)
        }
        
        if categories.count != 1 {
            // throws
        }
    
        return categories[0]
    }
    
    
    func insertCategory(category: ItemCategory) throws -> Int64 {
        
        let insert = categoriesTable.insert(
                categoryName <- category.getName()
        )
        
        if let categoryId = try database?.run(insert) {
            return categoryId
        }
        else {
            throw CategoryHandler.CategoryError.accessError
        }
    }
    
    
    func updateCategory(category: ItemCategory, rowId: Int64) throws -> Int {
        
        let filteredTable : Table = categoriesTable.filter(categoryId == rowId)

        let update = filteredTable.update(
            categoryName <- category.getName()
        )
        
        let numberOfUpdatedRows = try! database?.run(update)
        
        return numberOfUpdatedRows!
    }
    
    
    func removeCategory(rowId: Int64) throws -> Int {
        
        let filteredTable : Table = categoriesTable.filter(categoryId == rowId)
        if let numberOfDeletedRows = try! database?.run(filteredTable.delete()) {
            return numberOfDeletedRows
        } else {
            throw CategoryHandler.CategoryError.accessError
        }

    }
    
}

