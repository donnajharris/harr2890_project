//
//  ItemHelper.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-07.
//

import Foundation
import UIKit


class ItemHelper {
    
    
    // MARK: - Static helper functions relating to Item
    
    static func getTypeString(type: Item.ItemType) -> String {
        switch type {
        case Item.ItemType.ON:
            return "on"
        case Item.ItemType.BY:
            return "by"
        }
    }
    
    static func getTypeString(item: Item) -> String {
        
        let type = item.getType()
        
        switch type {
        case Item.ItemType.ON:
            return "on"
        case Item.ItemType.BY:
            return "by"
        }
    }
    
    static func isTypeString(_ string: String) -> Bool {
        if string.lowercased() == "on" || string.lowercased() == "by" {
            return true
        } else {
            return false
        }
    }
    
    static func translateToItemType(string : String) -> Item.ItemType? {
        if isTypeString(string) {
            switch string {
            case "on":
                return Item.ItemType.ON
            case "by":
                return Item.ItemType.BY
            default:
                return nil
            }
        }
        
        return nil
    }
    
    
    
    // Turns the segment control into somtehing usable, as an ItemType
    static func setType(typeField: UISegmentedControl) -> Item.ItemType {
        var type : Item.ItemType
        
        switch typeField.selectedSegmentIndex {
        case Item.ON:
            type = Item.ItemType.ON
        case Item.BY:
            type = Item.ItemType.BY
        default:
            type = Item.ItemType.ON
        }

        return type
        
    } // setType
}
