//
//  CategoryHandler.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import Foundation

class CategoryHandler {
    
    let databaseAccess : DatabaseAccess
    
    enum CategoryError : Error {
        case duplicateCategoryName
        case categoryNotFound
        case categoryIsNil
        case accessError
    }
    
    init(dal: DatabaseAccess) {
        databaseAccess = dal
    }
    
    func getCategoriesFromDB(tableData: inout [ItemCategory]) throws {
        
        var returnedData : [ItemCategory]
        
        do {
            try returnedData = databaseAccess.getAllCategories()
            
            sortDataByName(data: &returnedData)
            
            tableData = returnedData

        } catch CategoryError.accessError {
            
        }
        
    } // getCategoriesFromDB
    
    
    func addCategoryToDB(category: ItemCategory, tableData: inout [ItemCategory]) throws {

        var itemId : Int64
        
        do {
            try itemId = databaseAccess.insertCategory(category: category)
            
            if itemId > 0 {
                category.setId(value: itemId)
                tableData.append(category)
                sortDataByName(data: &tableData)
            }
            
        } catch CategoryError.duplicateCategoryName {
        
        } catch CategoryError.accessError {
            
        }
        
    } // addCategoryToDB
    
    
    // for a SINGLE removal
    func removeCategoryFromDB(indexToDelete: Int, category: ItemCategory, tableData: inout [ItemCategory]) throws {
        
        var numberOfDeletedRows : Int
        
        do {
            try numberOfDeletedRows = databaseAccess.removeCategory(rowId: category.getId()!)
            
            if numberOfDeletedRows == 1 {
                                
                tableData.remove(at: indexToDelete)
                //sortDataByName(data: &tableData)  // sorting should not be needed.... it should already be in order?
            }
            
        } catch CategoryError.categoryNotFound {
        
        } catch CategoryError.accessError {
            
        }
    } // removeCategoryFromDB
    
    
    // for a SINGLE update
    func updateCategoryInDB(category: ItemCategory, tableData: inout [ItemCategory]) throws {
        
        var numberOfUpdatedRows : Int
        
        do {
            
            try numberOfUpdatedRows = databaseAccess.updateCategory(category: category, rowId: category.getId()!)
            
            if numberOfUpdatedRows == 1 {
                if let index = tableData.firstIndex(where: { $0.getId() == category.getId() }) {
                    tableData[index] = category
                    sortDataByName(data: &tableData)
                }
            }
            
        } catch CategoryError.categoryNotFound {
        
        } catch CategoryError.accessError {
            
        }
    } // updateCategoryInDB

    
    
    // MARK: - Helper functions
    
    func sortDataByName(data: inout [ItemCategory]) {
        // Case is not a sort
        data.sort {
            $0.getName() < $1.getName()
        }
        
        // case is ignored
//
//        _ = data.sorted(by: { (category1, category2) -> Bool in
//            return category1.getName().localizedCompare(category2.getName()) == .orderedAscending
//        })
        
        
    } // sortDataByName
}
