//
//  CategoryViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import UIKit
import OSLog

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private var category : ItemCategory?

    func getNewCategory() -> ItemCategory? {
        return category
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func initWithCategory(category: ItemCategory) {
        self.category = category
    }

    
    // MARK: - Navigation
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
                
        // Prepare the returned Item to be added to the list
        let name = categoryName.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        category = ItemCategory(name: name)
        
        
        
        if CategoryHelper.categoryIsValid(category: category!) == false {
            category = nil
        }

    } // prepare
}
