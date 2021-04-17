//
//  ListViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//
//  ** The DEFAULT controller for the app **

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
}


class ListViewController: UITableViewController, UITabBarDelegate {
    
    @IBOutlet weak var myTableView: UITableView!

    let simpleTableIdentifier = "table_identifier"
    private let showSegueId = "ShowItemDetails"
    private let addSegueId = "AddingItem"
    private let cellIdentifier = "ListViewReuseIdentifier"
    private var items = [Item]() // the data source
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Consider removing this...
        // suppress the noise of the UI Constraint messages while developing logic
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        let bl = ItemBL()
        bl.loadItems(data: &items)
        
    } // viewDidLoad
    
    
    
    // TODO: Repurpose to add EXAMPLES that serve as instructions?
    func testAddDataToDB() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/05/2022")
        let item3 = Item(title: "Do something with roast beef!!!", date: date1!, type: Item.ItemType.BY, changed: false)

        //let resultId = try! database?.insertItem(item: item3)
        
        let bl = ItemBL()
        bl.addNewItem(item: item3, data: &items)
          
    } //testAddDataToDB

    
    // MARK: - TableView methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
                                    as? TableViewCell
              if (cell == nil) {
                  cell = TableViewCell(
                    style: UITableViewCell.CellStyle.default,
                    reuseIdentifier: cellIdentifier)
              }
        
            // set the cell item title
            cell?.title?.text = items[indexPath.row].getTitle()
                            
            // set the cell text
            cell?.date?.text = items[indexPath.row].getDateString()
        
            // set the preposition type text
            let helper = ItemHelper()
            cell?.type?.text = helper.getTypeString(item: items[indexPath.row])
        
            return cell! // return  the cell to the table view
        
    } // TV - cellForRowAt indexPath
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         tableView.deselectRow(at: indexPath, animated: true)
         performSegue(withIdentifier: showSegueId,
                      sender: items[indexPath.row])
        
    }  // TV - didSelectRowAt
    
    
    // REMOVING item from display AND database
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // IDEAS for archiving: https://stackoverflow.com/questions/48515945/swipe-to-delete-with-multiple-options
        
        if editingStyle == .delete {
            let indexToDelete = indexPath.row
            let itemToRemove = items[indexToDelete]
            
            let bl = ItemBL()
            try! bl.removeItem(index: indexToDelete, item: itemToRemove, data: &items)
            
            myTableView.deleteRows(at: [indexPath], with: .fade)
        }
    } // TV - editingStyle forRowAt
    
    
    
    // MARK: - Navigation
    
    // unwind from adding
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? AddItemViewController,
           let returnedItem = sourceVC.getNewItem() {
            
                let bl = ItemBL()
                bl.addNewItem(item: returnedItem, data: &items)
                myTableView.reloadData()
        } else {
            
            // This fails somewhat gracefully, but silently at the UI level
            print("Error adding the item")
        }
        
    } // unwindToItemList

    
    // returning up edits/viewing
    @IBAction func unwindToItemListFromView(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? ItemViewController,
           let returnedItem = sourceVC.getItem() {

            if returnedItem.hasChanged() {
                
                let bl = ItemBL()
                try! bl.updateItem(item: returnedItem, data: &items)
                myTableView.reloadData()
            }
        } else {
            
            // This fails somewhat gracefully, but silently at the UI level
            print("Error editing the selected item")
        }
        
    } // unwindToItemList
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == addSegueId {
            return
        }
        
        let item = sender as! Item
        print(item)

        // Reference: https://stackoverflow.com/questions/30209626/could-not-cast-value-of-type-uinavigationcontroller
        
        if segue.identifier == showSegueId {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ItemViewController
            vc.initWithItem(item: sender as! Item)
        }
        
    } // prepare - for segue
    
    

    // MARK: - Helper functions
    
    // initialize the data source
    func createData() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")


        let item2 = Item(title: "Credit card expires", date: date3!, type: Item.ItemType.ON, changed: false)
        items.append(item2)
        
        let item3 = Item(title: "Use roast beef", date: date1!, type: Item.ItemType.BY, changed: false)
        items.append(item3)
        
        let item1 = Item(title: "Passport expires", date: date2!, type: Item.ItemType.ON, changed: false)
        items.append(item1)
  
     } // createData

}
