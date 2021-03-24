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
    
    private let ON = 0
    private let BY = 1
    
    
    private var item : Item?

    func getNewItem() -> Item? {
        return item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        var type : Item.ItemType

        switch typeField.selectedSegmentIndex {
        case ON:
            type = Item.ItemType.ON
        case BY:
            type = Item.ItemType.BY
        default:
            type = Item.ItemType.ON
        }
    
        //print("The value selected is: \(type)")
                
        item = Item(title: title, date: date, type: type)

    } // prepare
 
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


}
