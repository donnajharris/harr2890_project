//
//  Item.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import Foundation

class Item {
    
    private var title : String
    private var date : String // will be a date
    
    init(title: String, date: String) {
        self.title = title
        self.date = date
    }
    
    
    func getTitle() -> String {
        return self.title
    }
    
    func getDate() -> String {
        return self.date
    }
    
}
