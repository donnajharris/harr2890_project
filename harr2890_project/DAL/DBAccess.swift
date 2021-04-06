//
//  DBAccess.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-30.
//

import Foundation
import SQLite


class DBAccess {
    
    private var database : Connection
    
    // Items table
    let itemsTable = Table("items")
    let itemId = Expression<Int64>("id")
    let itemTitle = Expression<String>("title")
    let itemType = Expression<String>("type")
    let itemDate = Expression<Date?>("date")
    
    
    
    init(path: String) {
       
        // should fail immediately if it doesn't work
        database = try! Connection(path)
        
        initItemsTable()
        
    } // init
    
    
    private func initItemsTable() {
        try! database.run(itemsTable.create(ifNotExists: true) { t in
            t.column(itemId, primaryKey: .autoincrement)
            t.column(itemTitle)
            t.column(itemType)
            t.column(itemDate)
        })
        // CREATE TABLE "items" (
        //     "id" INTEGER PRIMARY KEY NOT NULL,
        //     "title" TEXT,
        //     "type" TEXT,
        //     "date" DATE
        // )

    } // createItemsTable
    
    
    func insertItem(item: Item) -> Int64 {
        let insert = itemsTable.insert(
                itemTitle <- item.getTitle(),
                itemType <- Item.getTypeString(item: item),
                itemDate <- item.getDate()
        )
        
        let rowid = try! database.run(insert)
        // INSERT INTO "items" ("title", "type", "date") VALUES ('MyTitle', 'BY', DateObject)

        return rowid
        
    } // insertItem

    
    func getAllItems() -> [Item] {
        var items = [Item]()
        
        for itemRow in try! database.prepare(itemsTable) {
            print("id: \(itemRow[itemId]), title: \(itemRow[itemTitle]), type: \(itemRow[itemType]), date: \(itemRow[itemDate]!)")
            
            let item = Item(id: itemRow[itemId],
                            title: itemRow[itemTitle],
                            date: itemRow[itemDate]!,
                            type: Item.translateToItemType(string: itemRow[itemType])!)
            
            items.append(item)
        }
        
        return items
        
    } // getAllItems
    
    
    func removeItem(rowId: Int64) -> Int {
        
        let filteredTable : Table = itemsTable.filter(itemId == rowId)
        let result = try! database.run(filteredTable.delete())
        return result
        
    } // removeItem
    
}

