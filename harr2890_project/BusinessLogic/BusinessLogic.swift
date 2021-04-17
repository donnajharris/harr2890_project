//
//  BusinessLogic.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-17.
//

import Foundation

class BusinessLogic {
    
    static let bl = BusinessLogic()
    
    private let db : DatabaseAccess
    private let itemHandler : ItemHandler
    private let categoryHandler : CategoryHandler

    
    init() {
        db = try! ImplementedDatabaseAccess()
        itemHandler = ItemHandler(dal: db)
        categoryHandler = CategoryHandler(dal: db)
    }
    
    func loadItems(data: inout [Item]) {
  
        try! itemHandler.getItemsFromDB(tableData: &data)
        
    } // loadItems
    
    
    func addNewItem(item: Item, data: inout [Item]) {
        
        print(item)
        
        try! itemHandler.addItemToDB(item: item, tableData: &data)
        
    } // addNewItem
    
    
    func removeItem(index: Int, item: Item, data: inout [Item]) throws {
        
        if item.getId() != nil {
            try! itemHandler.removeItemFromDB(indexToDelete: index, item: item, tableData: &data)
        } else {
            throw ItemHandler.ItemError.itemIsNil
        }
        
    } // removeItem
    
    
    func updateItem(item: Item, data: inout [Item]) throws {
        
        try! itemHandler.updateItemInDB(item: item, tableData: &data)
        
    } // updateItem
    
    
    // MARK: - Categories
    
    func loadCategories(data: inout [ItemCategory]) {
  
        try! categoryHandler.getCategoriesFromDB(tableData: &data)
        
    } // loadRealCategories
    
    
    func addNewCategory(category: ItemCategory, data: inout [ItemCategory]) {
        
        try! categoryHandler.addCategoryToDB(category: category, tableData: &data)
        
    } // addNewCategory
    
    
    func removeCategory(index: Int, category: ItemCategory, data: inout [ItemCategory]) throws {
        
        if category == CategoryHelper.UNCATEGORIZED  {
            throw CategoryHandler.CategoryError.cannotRemoveUncategorized
        }
        
        if category.getId() != nil {
            try! categoryHandler.removeCategoryFromDB(indexToDelete: index, category: category, tableData: &data)
        } else {
            throw CategoryHandler.CategoryError.categoryIsNil
        }
        
    } // removeCategory
    
    
    func updateCategory(category: ItemCategory, data: inout [ItemCategory]) throws {
        
        try! categoryHandler.updateCategoryInDB(category: category, tableData: &data)
        
    } // updateCategory
    
    
}
