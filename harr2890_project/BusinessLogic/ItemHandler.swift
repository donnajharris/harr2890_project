//
//  ItemHandler.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-07.
//

import Foundation

class ItemHandler {
    
    let databaseAccess : DatabaseAccess
    
    enum ItemError : Error {
        case itemNotFound
        case itemIsNil
        case accessError
    }
    
    init(dal: DatabaseAccess) {
        databaseAccess = dal
    }
    
    
    func getItemsFromDB(tableData: inout [Item]) throws {
        
        var returnedData : [Item]
        
        do {
            try returnedData = databaseAccess.getAllItems()
            
            sortDataByDate(data: &returnedData)
            
            tableData = returnedData

        } catch ItemError.accessError {
            
        }
        
    } // getItemsFromDB
    
    
    func addItemToDB(item: Item, tableData: inout [Item]) throws {

        var itemId : Int64
        
        do {
            try itemId = databaseAccess.insertItem(item: item)
            
            if itemId > 0 {
                item.setId(value: itemId)
                tableData.append(item)
                sortDataByDate(data: &tableData)
            }
                    
        } catch ItemError.accessError {
            
        }
        
    } // addItemToDB
    
    
    // for a SINGLE removal
    func removeItemFromDB(indexToDelete: Int, item: Item, tableData: inout [Item]) throws {
        
        var numberOfDeletedRows : Int
        
        do {
            try numberOfDeletedRows = databaseAccess.removeItem(rowId: item.getId()!)
            
            if numberOfDeletedRows == 1 {
                                
                tableData.remove(at: indexToDelete)
            }
            
        } catch ItemError.itemNotFound {
        
        } catch ItemError.accessError {
            
        }
    } // removeItemFromDB
    
    
    // for a SINGLE update
    func updateItemInDB(item: Item, tableData: inout [Item]) throws {
        
        var numberOfUpdatedRows : Int
        
        do {
            
            try numberOfUpdatedRows = databaseAccess.updateItem(item: item, rowId: item.getId()!)
            
            if numberOfUpdatedRows == 1 {
                if let index = tableData.firstIndex(where: { $0.getId() == item.getId() }) {
                    tableData[index] = item
                    sortDataByDate(data: &tableData)
                }
            }
            
        } catch ItemError.itemNotFound {
        
        } catch ItemError.accessError {
            
        }
    } // updateItemInDB
    
    
    
    func getAllItemsWithLocationsFromDatabase(daysFilter: Int) -> [Item] {
        
        do {
            return try databaseAccess.getAllItemsWithLocations(daysFilter: daysFilter)

        } catch ItemError.accessError {
            
        } catch {
            
        }
        
        return [Item]() // empty if for reason it
    } // getAllItemsWithLocationsFromDatabase

    
    
    // MARK: - Helper functions
    
    func sortDataByDate(data: inout [Item]) {
        data.sort {
            $0.getDate() < $1.getDate()
        }
    } // sortDataByDate
    
}
