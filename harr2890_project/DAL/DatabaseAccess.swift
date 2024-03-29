//
//  DatabaseAccess.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import Foundation

protocol DatabaseAccess {
        
    init() throws
    
    // MARK: - Item operations
    func insertItem(item: Item) throws -> Int64
    func updateItem(item: Item, rowId: Int64) throws -> Int
    func removeItem(rowId: Int64) throws -> Int
    func getAllItems() throws -> [Item]
    func getItemsInCategory(categoryId: Int64) throws -> [Item]
    func getAllItemsWithLocations(daysFilter: Int) throws -> [Item]

    
    // MARK: - Category operations
    func insertCategory(category: ItemCategory) throws -> Int64
    func updateCategory(category: ItemCategory, rowId: Int64) throws -> Int
    func removeCategory(rowId: Int64) throws -> Int
    func getAllCategories() throws -> [ItemCategory]
    func getCategory(id: Int64) throws -> ItemCategory
}
