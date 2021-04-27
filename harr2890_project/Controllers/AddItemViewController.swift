//
//  AddItemViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import UIKit
import MapKit

class AddItemViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, MyDataSendingDelegateProtocol {
    
    private var category : ItemCategory? = nil
    
    func sendDataToFirstViewController(data: ItemCategory) {
        self.categoryLabel.text = data.getName()
        self.category = data
    }
    
    private let selectSegueId = "categorySelect"
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var typeField: UISegmentedControl!
    @IBOutlet weak var dateField: UIDatePicker!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var selectCategoryButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func addLocationButton(_ sender: Any) {
    }
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    private var item : Item?
    private var newLocation : CLLocationCoordinate2D?
    
    func getNewItem() -> Item? {
        return item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // default without time on date picker
//        dateField.datePickerMode = .date
//        dateField.preferredDatePickerStyle = .wheels
        
        // Handle the text field’s user input through delegate callbacks
        self.nameField.delegate = self // set delegate
        
        categoryLabel.text = "Uncategorized" // default label
        coordinatesLabel.text = "" // default label
        
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
                
        if segue.identifier == selectSegueId {
            
            let secondVC: SimpleCategoryListViewController = segue.destination as! SimpleCategoryListViewController
            secondVC.delegate = self
            return
        }
        
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton else {
            //print("The save button was not pressed, cancelling")
            return
        }
                
        // Prepare the returned Item to be added to the list
        let title = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let date = dateField.date
        
        let helper = ItemHelper()
        
        let type = helper.setType(typeField: typeField)
        
        if self.category == nil {
            self.category = CategoryHelper.UNCATEGORIZED
        }
        // isNew flag is set to indicate a new item
        if newLocation == nil {
            item = Item(title: title, date: date, type: type, category: self.category!, changed: true)
        } else {
            item = Item(title: title, date: date, type: type, category: self.category!, changed: true,
                        latitude: Double(newLocation!.latitude),
                        longitude: Double(newLocation!.longitude))
        }
            
        if helper.itemIsValid(item: item!) == false {
            item = nil
        }

    } // prepare
    
    
    @IBAction func unwindToAddItemWithLocation(_ unwindSegue: UIStoryboardSegue) {
        
        if let pickingMap = unwindSegue.source as? PickLocationMapViewController,
           let coordinates = pickingMap.getChosenLocation() {
            
                newLocation = coordinates
        
                coordinatesLabel.text = "Lat: " + String(newLocation!.latitude) + " \nLong: " + String(newLocation!.longitude)
        }
    } // unwindToAddItemWithLocation

}
