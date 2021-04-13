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
        
    } // getAllCategories
    
    
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
        
    } // addCatgoryToDB
    
    
    // MARK: - Helper functions
    
    func sortDataByName( data: inout [ItemCategory]) {
        data.sort {
            $0.getName() < $1.getName()
        }
    } // sortDataByName
}
