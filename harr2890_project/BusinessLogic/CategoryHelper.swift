//
//  CategoryHelper.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import Foundation

class CategoryHelper {
    
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
        
        return categories.contains(where: { $0.getName() == category.getName() })
                
    } // categoryAlreadyExists
    
    
    func categoryHasBeenChanged(category: ItemCategory, newName: String) -> Bool {
        
        if category.getName() == newName {
            return false
        }
        
        return true
    }
    
}
