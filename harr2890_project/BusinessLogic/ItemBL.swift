//
//  ItemBL.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-16.
//

import Foundation

class ItemBL {
    
    let db : DatabaseAccess
    let handler : ItemHandler
    
    init() {
        db = ImplementedDatabaseAccess()
        handler = ItemHandler(dal: db)
    }
    
    func loadItems(data: inout [Item]) {
  
        try! handler.getItemsFromDB(tableData: &data)
        
    } // loadItems
    
    
    func addNewItem(item: Item, data: inout [Item]) {
        
        try! handler.addItemToDB(item: item, tableData: &data)
        
    } // addNewItem
    
    
    func removeItem(index: Int, item: Item, data: inout [Item]) throws {
        
        if item.getId() != nil {
            try! handler.removeItemFromDB(indexToDelete: index, item: item, tableData: &data)
        } else {
            throw ItemHandler.ItemError.itemIsNil
        }
        
    } // removeItem
    
    
    func updateItem(item: Item, data: inout [Item]) throws {
        
        try! handler.updateItemInDB(item: item, tableData: &data)
        
    } // updateItem
    
}
