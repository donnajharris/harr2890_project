//
//  BusinessLayer.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import Foundation

class BusinessLayer {
    
    let db : DatabaseAccess
    let handler : CategoryHandler
    
    init() {
        //let db = ImplementedDatabaseAccess()
        //let handler = CategoryHandler(dal: db)
        
        db = ImplementedDatabaseAccess()
        handler = CategoryHandler(dal: db)
    }
    
    func loadCategories(data: inout [ItemCategory]) {
  
        try! handler.getCategoriesFromDB(tableData: &data)
        
    } // loadRealCategories
    
    
    func addNewCategory(category: ItemCategory, data: inout [ItemCategory]) {
        
        try! handler.addCategoryToDB(category: category, tableData: &data)
        
    } // addNewCategory
    
    
    func removeCategory(index: Int, category: ItemCategory, data: inout [ItemCategory]) throws {
        
        if category.getId() != nil {
            try! handler.removeCategoryFromDB(indexToDelete: index, category: category, tableData: &data)
        } else {
            throw CategoryHandler.CategoryError.categoryIsNil
        }
        
    } // removeCategory
    
    
    func updateCategory(category: ItemCategory, data: inout [ItemCategory]) throws {
        
        try! handler.updateCategoryInDB(category: category, tableData: &data)
        
    } // updateCategory
    
    
    
}
