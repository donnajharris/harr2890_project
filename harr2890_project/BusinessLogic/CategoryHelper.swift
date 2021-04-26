//
//  CategoryHelper.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import Foundation

class CategoryHelper {
    
    static let UNCATEGORIZED : ItemCategory = ItemCategory(id: 1, name: "Uncategorized")
    
    enum CategoryHelperError : Error {
        case invalidUsage
    }
    
    
    init() {
        
    }
    
    func categoryNameIsValid(categoryName: String) -> Bool {
        
        if categoryName == "" {
            return false
        }
        
        return true
    }
    
    
    func categoryAlreadyExists(category: ItemCategory, categories: [ItemCategory]) -> Bool {
        
        return categories.contains(where: {
            $0.getName().lowercased() == category.getName().lowercased()
        })

    } // categoryAlreadyExists
    
    
    func categoryWasRecased(before: String, updatedCategory: ItemCategory) -> Bool {
        
        if before == updatedCategory.getName() { return false }
        
        if before.lowercased() == updatedCategory.getName().lowercased() { return true }
        
        return false // would return if no match at all
    }
    
    
    func categoryHasBeenChanged(category: ItemCategory, newName: String) -> Bool {
        
        if category.getName() == newName {
            return false
        }
        
        return true
    }
    
}
