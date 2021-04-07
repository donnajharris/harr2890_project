//
//  AddItemViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import UIKit
import os.log

class AddItemViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UISegmentedControl!
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    
    private var item : Item?

    func getNewItem() -> Item? {
        return item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // default without time on date picker
        dateField.datePickerMode = .date
        dateField.preferredDatePickerStyle = .wheels
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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


        // isNew flag is set to indicate a new item
        item = Item(title: title, date: date, type: type, changed: true)

    } // prepare
    
    
    // TODO: this should be moved!
    
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
