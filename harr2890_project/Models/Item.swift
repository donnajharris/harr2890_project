//
//  Item.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import Foundation
import MapKit

class Item : Equatable, CustomStringConvertible {
    
    private let helper = ItemHelper()
    
    var description: String { return "ITEM Id: \(id!)\n\(title) \(helper.getTypeString(item: self)) \(getDateString())\nCategory: \(category.getName())\nChanged? \(changed)"}
    
    
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
    
    private var category : ItemCategory
    
    private var location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(Item.UNDEFINED)), longitude: CLLocationDegrees(Double(Item.UNDEFINED)))

    
    init(title: String, date: Date, type: ItemType, category: ItemCategory, changed: Bool) {
        self.id = Item.UNDEFINED
        self.title = title
        self.date = date
        self.type = type
        self.changed = changed
        self.category = category
    }
    
    init(title: String, date: Date, type: ItemType, category: ItemCategory, changed: Bool, latitude: Double, longitude: Double) {
        self.id = Item.UNDEFINED
        self.title = title
        self.date = date
        self.type = type
        self.changed = changed
        self.category = category
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    init(id: Int64, title: String, date: Date, type: ItemType, category: ItemCategory, changed: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.changed = changed
        self.category = category
    }
    
    init(id: Int64, title: String, date: Date, type: ItemType, category: ItemCategory, changed: Bool, latitude: Double, longitude: Double) {
        self.id = id
        self.title = title
        self.date = date
        self.type = type
        self.changed = changed
        self.category = category
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
    
    init(item: Item) {
        self.id = Int64(item.getId() ?? Item.UNDEFINED)
        self.title = String(item.getTitle())
        self.date = item.getDate()
        self.type = item.getType()
        self.changed = Bool(item.hasChanged())
        self.category = ItemCategory(category: item.getCategory() ?? CategoryHelper.UNCATEGORIZED)
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
    
    
    func setCategory(category: ItemCategory) {
        self.category = category
    }
    
    func getCategory() -> ItemCategory? {
        return self.category
    }
    
    
    // MARK: - Location properties for mapping
    
    func setLocation(coordinates: CLLocationCoordinate2D) {
        self.location = coordinates
    }
    
    func getLocation() -> CLLocationCoordinate2D? {
        return location
    }
    
    func getLatitude() -> Double {
        return location.latitude
    }
    
    func getLongitude() -> Double {
        return location.longitude
    }
    
    func getLocationStringToDisplay() -> String {
        
        var toDisplay = ""
        
        if location.latitude != Double(Item.UNDEFINED) && location.longitude != Double(Item.UNDEFINED) {
            toDisplay = "Lat: " + String(location.latitude) + " \nLong: " + String(location.longitude)
        } else {
            toDisplay = "No location defined."
        }
        
        return toDisplay
    } // getLocationStringToDisplay

}
