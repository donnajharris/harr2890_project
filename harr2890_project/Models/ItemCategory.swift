//
//  Category.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-11.
//

import Foundation

class ItemCategory : Equatable, CustomStringConvertible {
        
    var description: String { return "CATEGORY Id: \(id!)\n\(name)"}
    
    static func == (lhs: ItemCategory, rhs: ItemCategory) -> Bool {
        
        if lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    } // ==
    

    
    static let UNDEFINED : Int64 = -999
    
    private var id : Int64?
    private var name : String
    
    
    init(name: String) {
        self.id = ItemCategory.UNDEFINED
        self.name = name
    }
    
    init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }
    
    
    func getId() -> Int64? {
        return id
    }
    
    func setId(value : Int64) {
        id = value
    }
    
    
    func getName() -> String {
        return name
    }
    
    func setName(name: String) {
        self.name = name
    }
}
