//
//  Item.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import Foundation

class Item {
    
    private var title : String
    private var date : Date?
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
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
    
}
