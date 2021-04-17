//
//  CategoryViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import UIKit
import OSLog

class CategoryViewController: UIViewController {

    enum Mode {
        case add
        case edit
    }
    
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private var category : ItemCategory?
    private var mode : Mode = .add // default
    private var originalCategoryName : String?
    

    func getNewCategory() -> ItemCategory? {
        return category
    }
    
    func getMode() -> Mode {
        return mode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if mode == .edit {
            self.categoryName.text = category?.getName()
            self.originalCategoryName = category?.getName()
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func initWithCategory(category: ItemCategory) {
        self.category = category
        self.mode = .add
    }
    
    
    func updateWithCategory(category: ItemCategory) {
        self.category = category
        self.mode = .edit
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

        let helper = CategoryHelper()
        
        //if helper.categoryNameIsValid(category: category!) == false {
        if helper.categoryNameIsValid(categoryName: name) == false {
            category = nil
            return // TODO? Throw something instead, give error? prevent submission?
        }
        
        if mode == .add {
            category = ItemCategory(name: name)
            
        } else if mode == .edit && category != nil && originalCategoryName != nil {
                        
            if helper.categoryHasBeenChanged(category: category!, newName: categoryName.text!) {
                                
                category?.setName(name: categoryName.text!)
            }
            
        }

    } // prepare
}
