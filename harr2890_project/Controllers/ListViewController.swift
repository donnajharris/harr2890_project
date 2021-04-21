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
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var type: UILabel!
}


class ListViewController: UITableViewController, UITabBarDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    private let simpleTableIdentifier = "table_identifier"
    private let showSegueId = "ShowItemDetails"
    private let addSegueId = "AddingItem"
    private let cellIdentifier = "ListViewReuseIdentifier"
    
    private let ROW_HEIGHT = 70
    
    private var items = [Item]() // the data source
    private var filteredItems = [Item]() // the FILTERED data

    private var closeKeyboardButton : UIBarButtonItem? = nil
    private var keyboardToolbar : UIToolbar? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = BusinessLogic()
        
        // TODO: Consider removing this...
        // suppress the noise of the UI Constraint messages while developing logic
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        self.searchBar.delegate = self
        searchBar.placeholder = "Search for an item"
        
        /* References:
         https://stackoverflow.com/questions/6179534/add-a-button-to-hide-keyboard
         https://www.hackingwithswift.com/forums/swift/toolbar-button-location/5666
         */
        keyboardToolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.closeKeyboardButton = UIBarButtonItem(title: "Close Keyboard", style: .plain, target: self, action: #selector(self.donePressed))
        self.keyboardToolbar!.items = [flexSpace, self.closeKeyboardButton!]
        self.keyboardToolbar?.sizeToFit()
        self.searchBar.inputAccessoryView = self.keyboardToolbar
        
        //let bl = ItemBL()
        BusinessLogic.bl.loadItems(data: &filteredItems)
        
        items = filteredItems

        
    } // viewDidLoad
    
    
    
    // TODO: Repurpose to add EXAMPLES that serve as instructions?
    func testAddDataToDB() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/05/2022")
        let item3 = Item(title: "Do something with roast beef!!!", date: date1!, type: Item.ItemType.BY, category: CategoryHelper.UNCATEGORIZED, changed: false)

        //let resultId = try! database?.insertItem(item: item3)
        
        //let bl = ItemBL()
        BusinessLogic.bl.addNewItem(item: item3, data: &filteredItems)
          
    } //testAddDataToDB

    
    // MARK: - TableView methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredItems.count
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
        
            // set the cell item's category
            cell?.category?.text = filteredItems[indexPath.row].getCategory()?.getName()
        
            // set the cell item title
            cell?.title?.text = filteredItems[indexPath.row].getTitle()
                            
            // set the cell text
            cell?.date?.text = filteredItems[indexPath.row].getDateString()
        
            // set the preposition type text
            let helper = ItemHelper()
            cell?.type?.text = helper.getTypeString(item: filteredItems[indexPath.row])
        
            return cell! // return  the cell to the table view
        
    } // TV - cellForRowAt indexPath
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         tableView.deselectRow(at: indexPath, animated: true)
         performSegue(withIdentifier: showSegueId,
                      sender: filteredItems[indexPath.row])
        
    }  // TV - didSelectRowAt
    
    
    // REMOVING item from display AND database
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // IDEAS for archiving: https://stackoverflow.com/questions/48515945/swipe-to-delete-with-multiple-options
        
        if editingStyle == .delete {
            let indexToDelete = indexPath.row
            let itemToRemove = filteredItems[indexToDelete]
            
            try! BusinessLogic.bl.removeItem(index: indexToDelete, item: itemToRemove, data: &filteredItems)
            
            if self.searchBar.text?.isEmpty != nil {
                                
                BusinessLogic.bl.updateOriginalListAfterDeletingFromFilter(item: itemToRemove, data: &items)
            }
            
            myTableView.deleteRows(at: [indexPath], with: .fade)
        }
    } // TV - editingStyle forRowAt
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ROW_HEIGHT)
    }

    
    
    // MARK: - Navigation
    
    
    // unwind from adding
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? AddItemViewController,
           let returnedItem = sourceVC.getNewItem() {
                        
            if self.searchBar.text?.isEmpty != nil && self.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                
                BusinessLogic.bl.addNewItem(item: returnedItem, data: &items)

                let searchText = self.searchBar.text?.lowercased()
                
                BusinessLogic.bl.updateFilteredListAfterAdding(searchText: searchText!, item: returnedItem, data: &filteredItems)
            } else {
                BusinessLogic.bl.addNewItem(item: returnedItem, data: &filteredItems)
                BusinessLogic.bl.updateListAfterAdding(item: returnedItem, data: &items)
            }
            
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
                                
                if self.searchBar.text?.isEmpty != nil && self.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    
                    try! BusinessLogic.bl.updateItem(item: returnedItem, data: &items)
                    
                    let searchText = self.searchBar.text?.lowercased()
                    
                    BusinessLogic.bl.updateFilteredListAfterUpdating(searchText: searchText!, item: returnedItem, data: &filteredItems)
                } else {
                    try! BusinessLogic.bl.updateItem(item: returnedItem, data: &filteredItems)
                }
                
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
        
        //let item = sender as! Item
        //print(item)

        // Reference: https://stackoverflow.com/questions/30209626/could-not-cast-value-of-type-uinavigationcontroller
        
        if segue.identifier == showSegueId {
            let nav = segue.destination as! UINavigationController
            let vc = nav.topViewController as! ItemViewController
            vc.initWithItem(item: sender as! Item)
        }
        
    } // prepare - for segue
    
    
    // MARK: - Search Bar functionality
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            // refresh the view with original
            
            filteredItems = items
            myTableView.reloadData()
            return
        }
        
        filteredItems = items.filter({item -> Bool in
            item.getTitle().lowercased().contains(searchText.lowercased())
                || item.getCategory()!.getName().lowercased().contains(searchText.lowercased())
        })
        
        myTableView.reloadData()
    } // searchBar
    
    
    @IBAction func Tap(_ sender: UITapGestureRecognizer) {
        print("Tippity TAP!")
        self.searchBar.resignFirstResponder()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    

    // MARK: - Helper functions
    
    // initialize the data source
    func createData() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")


        let item2 = Item(title: "Credit card expires", date: date3!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false)
        filteredItems.append(item2)
        
        let item3 = Item(title: "Use roast beef", date: date1!, type: Item.ItemType.BY, category: CategoryHelper.UNCATEGORIZED, changed: false)
        filteredItems.append(item3)
        
        let item1 = Item(title: "Passport expires", date: date2!, type: Item.ItemType.ON, category: CategoryHelper.UNCATEGORIZED, changed: false)
        filteredItems.append(item1)
  
     } // createData

}
