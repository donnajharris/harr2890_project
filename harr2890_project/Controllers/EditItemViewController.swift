//
//  EditItemViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-06.
//

import UIKit
import os.log

class EditItemViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UISegmentedControl!
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    

    
    
    private var item : Item?

    func getChangedItem() -> Item? {
        return item
    }
    
    func editItem(item: Item) {
        self.item = item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // default without time on date picker
        dateField.datePickerMode = .date
        dateField.preferredDatePickerStyle = .wheels
                
        self.nameField.text = item!.getTitle()
        self.typeField.selectedSegmentIndex = item!.getTypeValue()
        self.dateField.date = item!.getDate()
        
        print("Enter the Edit Item view")
        print(item!)
    }
    
    
    // For the Save Button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
               
        // Add the returned Item to the list
        let title = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = dateField.date
        let type = setType(typeField: typeField)


        // new set to true because this item has changed
        item?.setTitle(value: title)
        item?.setType(value: type)
        item?.setDate(value: date)
        item?.setChangedFlag(changed: true)


    } // prepare
    
    
    // Turns the segment control into somtehing usable, as an ItemType
    func setType(typeField: UISegmentedControl) -> Item.ItemType {
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

