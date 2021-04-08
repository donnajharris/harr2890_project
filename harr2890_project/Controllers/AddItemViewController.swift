//
//  AddItemViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import UIKit
import os.log

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

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
        
        // Handle the text field’s user input through delegate callbacks
        self.nameField.delegate = self // set delegate
        
        // Enable the Save button only if the text fields have valid input
        updateSaveButtonState()

    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Tap(_ sender: UITapGestureRecognizer) {
        nameField.resignFirstResponder()
        typeField.resignFirstResponder()
        dateField.resignFirstResponder()
    }
    
    
    /* Reference:
     https://www.zerotoappstore.com/how-to-hide-keyboard-in-swift-return-key.html
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    } // textFieldShouldReturn
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disables the Save button while editing a text field
        saveButton.isEnabled = false
    } // textFieldDidBeginEditing
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    } // textFieldDidEndEditing

    private func updateSaveButtonState() {
        // Disable the Save button if the text fields are empty.
        let name = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let result = !name.isEmpty

        saveButton.isEnabled = result
    }  // updateSaveButtonState
    
    
    // For the Save Button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
                
        // Prepare the returned Item to be added to the list
        let title = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = dateField.date
        let type = ItemHelper.setType(typeField: typeField)

        // isNew flag is set to indicate a new item
        item = Item(title: title, date: date, type: type, changed: true)
        
        let handler = ItemHandler()
        
        if handler.itemIsValid(item: item!) == false {
            item = nil
        }

    } // prepare


}
