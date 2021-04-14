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
    private let DB_STRING = "itemsDB.plist"

    
    private var path : String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
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
    
    // Categories table
    let categoriesTable = Table("categories")
    let categoryId = Expression<Int64>("id")
    let categoryName = Expression<String>("name")
    
    
    
    //required init(path: String) {
    required init() {
        
        // should fail immediately if it doesn't work
        database = try! Connection(path)
        
        initItemsTable()
        initCategoriesTable()
        
    } // init
    
        
    private func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent(DB_STRING).path
        return url!
        
    } // dataFilePath
    
    
    private func initItemsTable() {
        try! database?.run(itemsTable.create(ifNotExists: true) { t in
            t.column(itemId, primaryKey: .autoincrement)
            t.column(itemTitle)
            t.column(itemType)
            t.column(itemDate)
        })
        // CREATE TABLE "items" (
        //     "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        //     "title" TEXT,
        //     "type" TEXT,
        //     "date" DATE
        // )

    } // createItemsTable
    
    
    private func initCategoriesTable() {
        try! database?.run(categoriesTable.create(ifNotExists: true) { t in
            t.column(categoryId, primaryKey: .autoincrement)
            t.column(categoryName)
        })
        // CREATE TABLE "categories" (
        //     "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        //     "name" TEXT
        // )

    } // createItemsTable
    
    
    
    // MARK: - Item operations
    
    func insertItem(item: Item) -> Int64 {
        
        let insert = itemsTable.insert(
                itemTitle <- item.getTitle(),
                itemType <- ItemHelper.getTypeString(item: item),
                itemDate <- item.getDate()
        )
        
        let itemId = try! database?.run(insert)
        // INSERT INTO "items" ("title", "type", "date") VALUES ('MyTitle', 'BY', DateObject)

        return itemId!
        
    } // insertItem
    
    
    func updateItem(item: Item, rowId: Int64) -> Int {
        
        let filteredTable : Table = itemsTable.filter(itemId == rowId)

        let update = filteredTable.update(
            itemTitle <- item.getTitle(),
            itemType <- ItemHelper.getTypeString(item: item),
            itemDate <- item.getDate()
        )
        
        let numberOfUpdatedRows = try! database?.run(update)
        
        return numberOfUpdatedRows!
    } // updateItem

    
    func getAllItems() -> [Item] {
        var items = [Item]()
        
        for itemRow in try! database!.prepare(itemsTable) {

            // print(itemRow)
            
            let item = Item(id: itemRow[itemId],
                            title: itemRow[itemTitle],
                            date: itemRow[itemDate]!,
                            type: ItemHelper.translateToItemType(string: itemRow[itemType])!,
                            changed: false)
            
            items.append(item)
        }
        
        return items
        
    } // getAllItems
    
    
    func removeItem(rowId: Int64) -> Int {
        
        let filteredTable : Table = itemsTable.filter(itemId == rowId)
        let numberOfDeletedRows = try! database?.run(filteredTable.delete())
        return numberOfDeletedRows!
        
    } // removeItem
    
    
    
    // MARK: - Category operations
    
    func getAllCategories() throws -> [ItemCategory] {
        
        print("\n\nIt's the REAL deal. Working.... getAllCategories()\n\n")
        var categories = [ItemCategory]()
        
        for categoryRow in try! database!.prepare(categoriesTable) {
            
            let category = ItemCategory(id: categoryRow[categoryId],
                                        name: categoryRow[categoryName]
            )
            
            categories.append(category)
        }
    
        return categories
    }
    
    
    func insertCategory(category: ItemCategory) throws -> Int64 {
        
        let insert = categoriesTable.insert(
                categoryName <- category.getName()
        )
        
        // INSERT INTO "categories" ("categoryName") VALUES ('Category Name')
        if let categoryId = try! database?.run(insert) {
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

