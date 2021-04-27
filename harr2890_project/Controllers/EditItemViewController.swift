//
//  EditItemViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-06.
//

import UIKit

class EditItemViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UISegmentedControl!
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryField: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var locationCoordinatesField: UILabel!
    
    private var item : Item?

    func getChangedItem() -> Item? {
        return item
    }
    
    func editItem(item: Item) {
        self.item = item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameField.text = item!.getTitle()
        self.typeField.selectedSegmentIndex = item!.getTypeValue()
        self.dateField.date = item!.getDate()
        
        if let categoryName = item?.getCategory()?.getName() {
            categoryField.text = categoryName
        } else {
            categoryLabel.text = ""
            categoryField.text = "" // display nothing
        }
        
        if let coordinatesString = item?.getLocationStringToDisplay() {
            if coordinatesString.starts(with: "Lat") {
                locationCoordinatesField.text = coordinatesString
            } else {
                coordinatesLabel.text = ""
                locationCoordinatesField.text = "" // display nothing
            }
        }
        
        
        self.nameField.delegate = self // set delegate

        self.saveButton.setTitle("Update Item", for: UIControl.State.normal)
        
    }
    
    
    // For the Save Button
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton else {
            //print("The save button was not pressed, cancelling")
            return
        }
  
        // Add the returned Item to the list
        let title = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = dateField.date
        
        let helper = ItemHelper()
        let type = helper.setType(typeField: typeField)


        // new set to true because this item has changed
        item?.setTitle(value: title)
        item?.setType(value: type)
        item?.setDate(value: date)
        item?.setChangedFlag(changed: true)

        if helper.itemIsValid(item: item!) == false {
            item = nil
        }

    } // prepare
    
    
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
    
    

}

