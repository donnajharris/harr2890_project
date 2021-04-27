//
//  CategoryViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-12.
//

import UIKit

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
            self.originalCategoryName = String(category?.getName() ?? "")
            
            self.navigationItem.title = "Edit Category Name"
            
            self.saveButton.setTitle("Update", for: UIControl.State.normal)
            
        }
    }
    
    
    func initWithCategory(category: ItemCategory) {
        self.category = ItemCategory(category: category)
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
            //print("The save button was not pressed, cancelling")
            return
        }
                
        // Prepare the returned Category to be added to the list
        categoryName.text = categoryName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = categoryName.text!
        
        let helper = CategoryHelper()
        
        if helper.categoryNameIsValid(categoryName: name) == false {
            category = nil
            popupForInvalidName()
            return
        } else if name == originalCategoryName?.trimmingCharacters(in: .whitespacesAndNewlines) {
            category = nil
            return // TODO
        }
        
        if mode == .add {
            category = ItemCategory(name: name)
            
        } else if mode == .edit && category != nil && originalCategoryName != nil {
                        
            if helper.categoryHasBeenChanged(category: category!, newName: categoryName.text!) {
                category?.setName(name: categoryName.text!)
            }
            
        }

    } // prepare
    
    
    
    private func popupForInvalidName() {
        let alertController = UIAlertController(title: "Sorry...",
                                                message: "The category name provided was not valid.",
                                                preferredStyle: UIAlertController.Style.alert)

//        alertController.addAction(UIAlertAction(title: "Dismiss",
//                                                style: UIAlertAction.Style.default,
//                                                handler: nil))

        self.present(alertController, animated: true, completion: nil)
        
        
        // Reference: comment 2 on https://stackoverflow.com/questions/27613926/dismiss-uialertview-after-5-seconds-swift
        
        print("We're waititng .... 5....")
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alertController.dismiss(animated: true, completion: nil)
        }
        
        print("All done...")
        
    } // popupForCategoryNameExists

    

    private func popupForCategoryNameExists() {
        let alertController = UIAlertController(title: "Sorry...",
                                                message: "That category name already exists.",
                                                preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,
                                                handler: nil))

        self.present(alertController, animated: true, completion: nil)
        
        
    } // popupForCategoryNameExists

    
}
