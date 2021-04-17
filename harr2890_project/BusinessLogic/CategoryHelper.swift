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
    
//    func categoryNameIsValid(category: ItemCategory) -> Bool {
//
//        if category.getName() == "" {
//            return false
//        }
//
//        return true
//    }
//
    
    func categoryAlreadyExists(category: ItemCategory, categories: [ItemCategory]) -> Bool {
        
        return categories.contains(where: { $0.getName() == category.getName() })
                
    } // categoryAlreadyExists
    
    
    func categoryHasBeenChanged(category: ItemCategory, newName: String) -> Bool {
        
        if category.getName() == newName {
            return false
        }
        
        return true
    }
    
//
//    func categoryHasBeenChanged(category: ItemCategory, categories: [ItemCategory]) throws -> Bool {
//
//        let index = categories.firstIndex(where: { $0.getId() == category.getId() })
//
//        print("index = \(index)")
//
//        /* THE PROBLEM IS...
//
//            the "categories" array is ALREADY changed before I run any checks or try to update the DB
//
//            the check that it's unique is failing as a result.... but if I remove the "else return" the ui updates
//
//         */
//
//
//        if index != nil {
//            print("categories[index!].getName() = \(categories[index!].getName())")
//            if categories[index!].getName() == category.getName() {
//                print("And here...")
//                return false
//            }
//
//            return true
//        } else {
//            //return false // or throw error
//            throw CategoryHelperError.invalidUsage
//        }
//
//    } //categoryHasBeenUpdated
    
}
