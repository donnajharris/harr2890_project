//
//  Mock_DBAccess.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-07.
//

import Foundation


class MockedDatabaseAccess : DatabaseAccess {
    
    
    //required init(path: String) {
    required init() {
       
        // should fail immediately if it doesn't work
//        database = try! Connection(path)
//
//        initItemsTable()
        
    } // init
    
    
    // MARK: - Item operations
    
    private func initItemsTable() {
//        try! database.run(itemsTable.create(ifNotExists: true) { t in
//            t.column(itemId, primaryKey: .autoincrement)
//            t.column(itemTitle)
//            t.column(itemType)
//            t.column(itemDate)
//        })
        
        // CREATE TABLE "items" (
        //     "id" INTEGER PRIMARY KEY NOT NULL,
        //     "title" TEXT,
        //     "type" TEXT,
        //     "date" DATE
        // )

    } // createItemsTable
    
    
    func insertItem(item: Item) -> Int64 {
        
//        let insert = itemsTable.insert(
//                itemTitle <- item.getTitle(),
//                itemType <- Item.getTypeString(item: item),
//                itemDate <- item.getDate()
//        )
//
//        let itemId = try! database.run(insert)
//        // INSERT INTO "items" ("title", "type", "date") VALUES ('MyTitle', 'BY', DateObject)

        let itemId : Int64 = 78
        
        return itemId
        
    } // insertItem
    
    
    func updateItem(item: Item, rowId: Int64) -> Int {
        
//        let filteredTable : Table = itemsTable.filter(itemId == rowId)
//
//        let update = filteredTable.update(
//            itemTitle <- item.getTitle(),
//            itemType <- Item.getTypeString(item: item),
//            itemDate <- item.getDate()
//        )
//
        let updatedRows : Int = 1  //= try! database.run(update)
        
        return updatedRows
    } // updateItem

    
    func getAllItems() -> [Item] {
        var items = [Item]()
        
//        for itemRow in try! database.prepare(itemsTable) {
//
//            // print(itemRow)
//
//            let item = Item(id: itemRow[itemId],
//                            title: itemRow[itemTitle],
//                            date: itemRow[itemDate]!,
//                            type: Item.translateToItemType(string: itemRow[itemType])!,
//                            changed: false)
//
//            items.append(item)
//        }
        
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
        
        return items
        
    } // getAllItems
    
    
    func removeItem(rowId: Int64) -> Int {
        
//        let filteredTable : Table = itemsTable.filter(itemId == rowId)
//        let result = try! database.run(filteredTable.delete())
        
        let result : Int = 1
        
        return result
        
    } // removeItem
    
    
    // MARK: - Category operations
    
    func getAllCategories() throws -> [ItemCategory] {
        
        print("\n\nIt's the MOCKED layer. Working.... getAllCategories()\n\n")

        // This data is designed to be out of order
        var categoriesInIdOrder = [ItemCategory]()
        categoriesInIdOrder.append(ItemCategory(id: Int64(1), name: "Second Category"))
        categoriesInIdOrder.append(ItemCategory(id: Int64(2), name: "Third Category"))
        categoriesInIdOrder.append(ItemCategory(id: Int64(3), name: "First Category"))
        
        return categoriesInIdOrder
    }
    
    func insertCategory(category: ItemCategory) throws -> Int64 {
                
        return Int64(4)  // value that matches with Happy Path test
    }
    
    func updateCategory(category: ItemCategory, rowId: Int64) -> Int {
        return Int(ItemCategory.UNDEFINED)

    }
    
    func removeCategory(rowId: Int64) -> Int {
        return Int(ItemCategory.UNDEFINED)

    }
    
}

