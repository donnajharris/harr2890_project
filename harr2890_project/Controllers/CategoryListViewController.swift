//
//  CategoryListViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-11.
//

import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
   // @IBOutlet weak var editName: UITextField!
}

class CategoryListViewController: UITableViewController {

    private let cellIdentifier = "ReuseIdentifier"
    private let addSegueId = "categoryAdd"

    private var categories = [ItemCategory]() // the data source
    
    @IBOutlet weak var myTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
                        
        //loadDummyCategories()
        
        let bl = BusinessLayer()
        bl.loadCategories(data: &categories)
    
    }
    
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        myTableView.reloadData()
//
//    }
    
    
    // unwind from adding
    @IBAction func unwindToCategoryList(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? CategoryViewController,
           let newCategory = sourceVC.getNewCategory() {

            let bl = BusinessLayer()
            
            bl.addNewCategory(category: newCategory, data: &categories)
            
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
        
        let category = sender as! ItemCategory
        print(category)

        // Reference: https://stackoverflow.com/questions/30209626/could-not-cast-value-of-type-uinavigationcontroller
        
        if segue.identifier == addSegueId {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! CategoryViewController
            vc.initWithCategory(category: sender as! ItemCategory)
        }
        
    } // prepare - for segue
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

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
                                    
            return cell! // return  the cell to the table view
        
    } // TV - cellForRowAt indexPath
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let indexToDelete = indexPath.row
            let categoryToRemove = categories[indexToDelete]
            
            let bl = BusinessLayer()
            try! bl.removeCategory(index: indexToDelete, category: categoryToRemove, data: &categories)
            
            myTableView.deleteRows(at: [indexPath], with: .fade)
            //myTableView.reloadData()
            

        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func loadDummyCategories() {
        
        let count = 10
        var i = 0
        
        while i < count {
            
            let catName = "Category \(i+1)"
            
            let cat = ItemCategory(name: catName)
            categories.append(cat)
            
            i += 1
        }
        
        
        // check it
        
        for e in categories {
            print("\(e.getName())")
        }
        
    }

}
