//
//  CategoryListViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-11.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class CategoryListViewController: UITableViewController {

    private let cellIdentifier = "ReuseIdentifier"
    private let addSegueId = "categoryAdd"
    private let editSegueId = "categoryEdit"
    private var categories = [ItemCategory]() // the data source
        
    @IBOutlet weak var myTableView: UITableView!
    
    private var lastSelectedCategoryName : String? = nil
    private var categoryNamesBefore : [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        BusinessLogic.layer.loadCategories(data: &categories)
    
    }
    
    // unwind from adding or editing
    @IBAction func unwindToCategoryList(sender: UIStoryboardSegue) {
    
        if let sourceVC = sender.source as? CategoryViewController,
           let returnedCategory = sourceVC.getNewCategory() {

            let mode = sourceVC.getMode()

            let helper = CategoryHelper()
            
            if mode == .add && !helper.categoryAlreadyExists(category: returnedCategory, categories: categories) {
                try! BusinessLogic.layer.addNewCategory(category: returnedCategory, data: &categories)
                
            } else if mode == .edit {
              
                if  helper.categoryWasRecased(before: lastSelectedCategoryName!, updatedCategory: returnedCategory) ||
                    !helper.categoryNameAlreadyExists(newCategoryName: returnedCategory.getName(), categoryNames: categoryNamesBefore) {
                
                    try! BusinessLogic.layer.updateCategory(category: returnedCategory, data: &categories)
                    BusinessLogic.layer.setCategoriesChanged(didChange: true)
                } else  {
                    print("Error: Cannot add a category with a name that already exists.")
                    
                    // reset category name back to original in table list
                    returnedCategory.setName(name: lastSelectedCategoryName!)
                    
                }
            }
            myTableView.reloadData()
        
        } else {
            
            // This fails somewhat gracefully, but silently at the UI level
            print("Error adding the category")
        }
        
    } // unwindToCategoryList
    
    
    private func setNamesOfListBefore() {
        
        categoryNamesBefore = [String]()
        
        for category in categories {
            categoryNamesBefore.append(category.getName())
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        // no prep to do for the adding category segue
        if segue.identifier == addSegueId {
            return
        }
        
        // Reference: https://stackoverflow.com/questions/30209626/could-not-cast-value-of-type-uinavigationcontroller
        
        if segue.identifier == editSegueId {
                        
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! CategoryViewController
            vc.updateWithCategory(category: sender as! ItemCategory)
        }
        
    } // prepare - for segue
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
                                    as? CategoryCell
              if (cell == nil) {
                  cell = CategoryCell(
                    style: UITableViewCell.CellStyle.default,
                    reuseIdentifier: cellIdentifier)
              }
        
            cell?.name?.text = categories[indexPath.row].getName()
                                    
            return cell! // return the cell to the table view
        
    } // TV - cellForRowAt indexPath
    
    
    // edit category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        lastSelectedCategoryName = categories[indexPath.row].getName()
        
        setNamesOfListBefore()

        if lastSelectedCategoryName != CategoryHelper.UNCATEGORIZED.getName() {
                    
            performSegue(withIdentifier: editSegueId,
                      sender: categories[indexPath.row])
            
        } else {
            popupForUncategorized()
        }
        

    }  // TV - didSelectRowAt
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if categories[indexPath.row].getName() == CategoryHelper.UNCATEGORIZED.getName() {
            popupForUncategorized()
            return
        }
        
        if editingStyle == .delete {
            
            let indexToDelete = indexPath.row
            let categoryToRemove = categories[indexToDelete]
            
            if BusinessLogic.layer.categoryHasItems(categoryId: categoryToRemove.getId()!) {
                popupForCategoryCannotBeDeletedYet()
            } else {
            
                do {
                    try BusinessLogic.layer.removeCategory(index: indexToDelete, category: categoryToRemove, data: &categories)
                    
                } catch CategoryHandler.CategoryError.cannotRemoveUncategorized {
                    
                    popupForUncategorized()
                    
                } catch {
                    // other things
                }
                
                myTableView.deleteRows(at: [indexPath], with: .fade)
            }

        }
    } // TV - commit editingStyle

    
    // MARK: - Popup Alerts
    
    private func popupForUncategorized() {
        let alertController = UIAlertController(title: "Sorry...",
                                                message: "The 'Uncategorized' category cannot be altered.",
                                                preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,handler: nil))

        self.present(alertController, animated: true, completion: nil)
        
    } // popupForUncategorized
    
    
    private func popupForCategoryCannotBeDeletedYet() {
        let alertController = UIAlertController(title: "Sorry...",
                                                message: "That category cannot be deleted while it has items associated with it.",
                                                preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,handler: nil))

        self.present(alertController, animated: true, completion: nil)
        
    } // popupForCategoryCannotBeDeletedYet
    
     

}
