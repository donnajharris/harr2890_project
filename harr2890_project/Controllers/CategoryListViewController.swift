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
    
    private var lastSelectedCategory : String? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        BusinessLogic.layer.loadCategories(data: &categories)
    
    }
    
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        myTableView.reloadData()
//
//    }
    
    
    // unwind from adding or editing
    @IBAction func unwindToCategoryList(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? CategoryViewController,
           let returnedCategory = sourceVC.getNewCategory() {

            let mode = sourceVC.getMode()

            let helper = CategoryHelper()
            
            if mode == .add && !helper.categoryAlreadyExists(category: returnedCategory, categories: categories) {
                BusinessLogic.layer.addNewCategory(category: returnedCategory, data: &categories)
                
            } else if mode == .edit {
                
                if  helper.categoryWasRecased(before: lastSelectedCategory!, updatedCategory: returnedCategory) ||
                    !helper.categoryAlreadyExists(category: returnedCategory, categories: categories) {
                
                    try! BusinessLogic.layer.updateCategory(category: returnedCategory, data: &categories)
                    BusinessLogic.layer.setCategoriesChanged(didChange: true)
                }
            }
            myTableView.reloadData()
            
        } else {
            
            // This fails somewhat gracefully, but silently at the UI level
            print("Error adding the category")
        }
        
    } // unwindToCategoryList
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == addSegueId {
            return
        }
        
        let category = ItemCategory(category: sender as! ItemCategory)

        // Reference: https://stackoverflow.com/questions/30209626/could-not-cast-value-of-type-uinavigationcontroller
        
        if segue.identifier == addSegueId {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! CategoryViewController
            vc.initWithCategory(category: sender as! ItemCategory)
        } else if segue.identifier == editSegueId {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! CategoryViewController
            vc.updateWithCategory(category: category)
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        lastSelectedCategory = categories[indexPath.row].getName()

        if lastSelectedCategory != CategoryHelper.UNCATEGORIZED.getName() {
        
            performSegue(withIdentifier: editSegueId,
                      sender: categories[indexPath.row])
        } else {
            popupForUncategorized()
        }
        

    }  // TV - didSelectRowAt
    
    private func popupForUncategorized() {
        let alertController = UIAlertController(title: "Sorry...",
                                                message: "The 'Uncategorized' category cannot be altered.",
                                                preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: "Dismiss",
                                                style: UIAlertAction.Style.default,handler: nil))

        self.present(alertController, animated: true, completion: nil)
        
    } // popupForUncategorized

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if categories[indexPath.row].getName() == CategoryHelper.UNCATEGORIZED.getName() {
            popupForUncategorized()
            return
        }
        
        if editingStyle == .delete {
            
            let indexToDelete = indexPath.row
            let categoryToRemove = categories[indexToDelete]
            
            do {
                try BusinessLogic.layer.removeCategory(index: indexToDelete, category: categoryToRemove, data: &categories)
                
            } catch CategoryHandler.CategoryError.cannotRemoveUncategorized {
                
                popupForUncategorized()
                
            } catch {
                // other things
            }
            
            myTableView.deleteRows(at: [indexPath], with: .fade)

        }
    } // TV - commit editingStyle

}
