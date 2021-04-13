//
//  CategoryHelper.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import Foundation

class CategoryHelper {
    
    
    static func categoryIsValid(category: ItemCategory) -> Bool {
        
        if category.getName() == "" {
            return false
        }
        
        return true
    }
}
