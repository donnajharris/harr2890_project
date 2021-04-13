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

    private var categories = [ItemCategory]() // the data source
    
    @IBOutlet weak var myTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.leftBarButtonItem = editButtonItem
        
        //loadDummyCategories()
        
        let bl = BusinessLayer()
        
        // TEST FIRST
//        let testCat = ItemCategory(name: "In Context")
//        bl.addNewCategory(category: testCat, data: &categories)

        // REAL
        bl.loadCategories(data: &categories)
        
        print(categories.count)
        
        for c in categories {
            print(c)
        }
        
        //categories.append(ItemCategory(id: 55, name: "55!"))
                
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        myTableView.reloadData()
//
//    }
    

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
        
//            cell?.editName?.text = categories[indexPath.row].getName()
//            cell?.editName?.isUserInteractionEnabled = false
                            
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
            
            // first
            categories.remove(at: indexPath.row)
            
            // second - Delete the row from the data source
            myTableView.deleteRows(at: [indexPath], with: .fade)
            
            
            // third - TODO: remove from database
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            

            
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
