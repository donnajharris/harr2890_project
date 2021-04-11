//
//  Category.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-11.
//

import Foundation

class Category {
    
    private var name : String
    
    init(name: String) {
        self.name = name
    }
    
    
    func getName() -> String {
        return name
    }
    
    func setName(name: String) {
        self.name = name
    }
}
