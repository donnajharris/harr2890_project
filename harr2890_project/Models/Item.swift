//
//  Item.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import Foundation

class Item : Equatable, CustomStringConvertible {
    
    var description: String { return "ITEM Id: \(id!)\n\(title) \(Item.getTypeString(item: self)) \(getDateString())\nChanged? \(changed)"}
    
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        
        if lhs.title == rhs.title &&
            lhs.type == rhs.type &&
            lhs.date == rhs.date {
            return true
        } else {
            return false
        }
    } // ==
    

    enum ItemType {
        case ON
        case BY
    }
    
    static let UNDEFINED : Int64 = -999
    
    // The order of the segmented controls in storyboard
    static let ON = 0
    static let BY = 1
    
    
    
    private var id : Int64?
    private var title : String
    private var type : ItemType
    private var date : Date?
    
    private var changed : Bool
    
    
    init(title: String, date: Date, type: ItemType, changed: Bool) {
        self.id = Item.UNDEFINED
        self.title = title
        self.date = date
        self.type = type
        self.changed = changed
    }
    
    init(id: Int64, title: String, date: Date, type: ItemType, changed: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.changed = changed

    }
    
    func getId() -> Int64? {
        return id
    }
    
    func setId(value : Int64) {
        id = value
    }
    
    
    func getTitle() -> String {
        return self.title
    }
    
    func setTitle(value : String) {
        title = value
    }
    
    
    func getDate() -> Date {
        return self.date!
    }
    
    func setDate(value : Date) {
        date = value
    }
    
    
    /*
     Reference: https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
     */
    func getDateString() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM. d, yyyy"
        var result = formatter.string(from: self.date!)
        
        if result.hasPrefix("May.") {
            result = result.replacingOccurrences(of: ".", with: "")
        }
        
        return result
    }
    
    
    func getType() -> ItemType {
        return self.type
    }
    
    func setType(value: ItemType ) {
        type = value
    }
    
    func getTypeValue() -> Int {
        switch type {
        case ItemType.ON:
            return Item.ON
        case ItemType.BY:
            return Item.BY
        }
    }
    
    
    func setChangedFlag(changed: Bool) {
        self.changed = changed
    }
    
    func hasChanged() -> Bool {
        return self.changed
    }
    
    
    // MARK: - Static helper functions relating to Item
    
    static func getTypeString(type: ItemType) -> String {
        switch type {
        case ItemType.ON:
            return "on"
        case ItemType.BY:
            return "by"
        }
    }
    
    static func getTypeString(item: Item) -> String {
        
        let type = item.getType()
        
        switch type {
        case ItemType.ON:
            return "on"
        case ItemType.BY:
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
    
    static func translateToItemType(string : String) -> ItemType? {
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
    
}
