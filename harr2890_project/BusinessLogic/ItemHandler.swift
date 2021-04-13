//
//  ItemHandler.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-07.
//

import Foundation

class ItemHandler {
    
    init() {
        
    }
    

    func itemIsValid(item: Item) -> Bool {
        
        if item.getTitle() == "" {
            return false
        }
        
        return true
    }
    
}
