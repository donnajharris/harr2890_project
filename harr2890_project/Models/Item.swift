//
//  Item.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import Foundation

class Item {


    enum ItemType {
        case ON
        case BY
    }
    
    // The order of the segmented controls in storyboard
    static let ON = 0
    static let BY = 1
    
    
    
    private var id : Int64?
    private var title : String
    private var type : ItemType
    private var date : Date?
    
    init(title: String, date: Date, type: ItemType) {
        self.title = title
        self.date = date
        self.type = type
    }
    
    init(id: Int64, title: String, date: Date, type: ItemType) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
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
    
    func getDate() -> Date {
        return self.date!
    }
    
    /*
     reference: https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
     */
    func getDateString() -> String {
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "MMM. d, yyyy"
        return formatter1.string(from: self.date!)
    }
    
    
    func getType() -> ItemType {
        return self.type
    }
    
    func getTypeValue() -> Int {
        switch type {
        case ItemType.ON:
            return Item.ON
        case ItemType.BY:
            return Item.BY
        }
    }
    
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
