//
//  SimpleCategoryListViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-17.
//

import UIKit
import OSLog


class SimpleCategoryCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class SimpleCategoryListViewController: UITableViewController {

    private let selectSegueId = "categorySelect"
    private let cellIdentifier = "ReuseIdentifier"
    private var categories = [ItemCategory]() // the data source
    
    @IBOutlet weak var myTableView: UITableView!
    
    private var category : ItemCategory?
    
    func getSelectedCategory() -> ItemCategory? {
        return category
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        let bl = CategoryBL()
        bl.loadCategories(data: &categories)
                
        for e in categories {
            print(e)
        }
    
    }
    
    

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
                                    as? SimpleCategoryCell
              if (cell == nil) {
                  cell = SimpleCategoryCell(
                    style: UITableViewCell.CellStyle.default,
                    reuseIdentifier: cellIdentifier)
              }
        
            cell?.name?.text = categories[indexPath.row].getName()
                                    
            return cell! // return  the cell to the table view
        
    } // TV - cellForRowAt indexPath
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         tableView.deselectRow(at: indexPath, animated: true)
         //performSegue(withIdentifier: selectSegueId, sender: categories[indexPath.row])
        
        //category?.setName(name: categories[indexPath.row].getName())
        category = categories[indexPath.row]
//        
//        print("\n\nShould work: \(categories[indexPath.row].getName())\n\n")
//        
//        print("\nDouble checking: \(category!.getName())")

    }  // TV - didSelectRowAt
    

}
