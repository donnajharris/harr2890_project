//
//  DatabaseAccess.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import Foundation

protocol DatabaseAccess {
        
    //init(path: String)
    init()
    
    
    // MARK: - Item operations
    func insertItem(item: Item) -> Int64
    func updateItem(item: Item, rowId: Int64) -> Int
    func removeItem(rowId: Int64) -> Int
    func getAllItems() -> [Item]
    
    
    // MARK: - Category operations
    func insertCategory(category: ItemCategory) throws -> Int64
    func updateCategory(category: ItemCategory, rowId: Int64) throws -> Int
    func removeCategory(rowId: Int64) throws -> Int
    func getAllCategories() throws -> [ItemCategory]

}
