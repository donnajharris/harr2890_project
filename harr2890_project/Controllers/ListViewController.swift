//
//  ListViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//
//  ** The DEFAULT controller for the app **

import UIKit

let NO_DB = 0
let WITH_DB = 1

let MODE = WITH_DB //NO_DB

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
    private var tableData = [Item]() // the data source
    
    
    //var database:OpaquePointer? = nil
    private var database : DBAccess? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // suppress the noise of the UI Constraint messages while developing logic
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        switch MODE {
        case NO_DB:
            createData()
            
        case WITH_DB:
            let path = dataFilePath()
            //print("path = \(path)")
            database = DBAccess(path: path)
            // then get the data...
        
        //TEST
            //testAddDataToDB()
            testGetAllDataFromDB()  // TODO: rework this to get something else on startup?
            //testDeleteRow1()
            
        default:
            createData()
        }
        
        sortDataByDate()
        
        
    } // viewDidLoad
    
    
    
    // TODO: Repurpose to add EXAMPLES that serve as instructions?
    func testAddDataToDB() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/05/2022")
        let item3 = Item(title: "Do something with roast beef!!!", date: date1!, type: Item.ItemType.BY, changed: false)

        let resultId = database?.insertItem(item: item3)
        
        print("result = \(resultId!)")
        
        item3.setId(value: resultId!)
        
    } //testAddDataToDB
    
    
    func testDeleteRow1() {
        
        let result = database?.removeItem(rowId: 1)
        print("result = \(result!)")

    } // testDeleteRow1
    
    
    func testGetAllDataFromDB() {
        let result = database?.getAllItems()
        //print("result = \(result!)")
        
        tableData = result!

    } // testGetAllDataFromDB
    
    
    
    // MARK: - TableView methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tableData.count
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
            cell?.title?.text = tableData[indexPath.row].getTitle()
                            
            // set the cell text
            cell?.date?.text = tableData[indexPath.row].getDateString()
        
            // set the preposition type text
            cell?.type?.text = Item.getTypeString(item: tableData[indexPath.row])
        
            return cell! // return  the cell to the table view
        
    } // TV - cellForRowAt indexPath
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("\n\nYou selected row \(indexPath) -- good job!\n\n")
        
         tableView.deselectRow(at: indexPath, animated: true)
         performSegue(withIdentifier: showSegueId,
                      sender: tableData[indexPath.row])
        
        print(tableData[indexPath.row])

    }  // TV - didSelectRowAt
    
    
    // REMOVING item from display AND database
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // IDEAS for archiving: https://stackoverflow.com/questions/48515945/swipe-to-delete-with-multiple-options
        
        if editingStyle == .delete {
            let itemId = tableData[indexPath.row].getId()
            
            tableData.remove(at: indexPath.row)


            let result = database?.removeItem(rowId: Int64(itemId!))
            print("remove from DB result = \(result!)")

            myTableView.deleteRows(at: [indexPath], with: .fade)
        }
    } // TV - editingStyle forRowAt
    
    
    
    // MARK: - Navigation
    
    // unwind from adding
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? AddItemViewController,
           let newItem = sourceVC.getNewItem() {

                // Add a new item.
                let newIndexPath = IndexPath(row: tableData.count, section: 0)
            
                tableData.append(newItem)
                myTableView.insertRows(at: [newIndexPath], with: .automatic)
            
                // add item to the DB
                let rowId = database?.insertItem(item: newItem)
                newItem.setId(value: rowId!)
            
                sortDataByDate()
                myTableView.reloadData()
        }
    } // unwindToItemList

    
    // returning up edits/viewing
    @IBAction func unwindToItemListFromView(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? ItemViewController,
           let item = sourceVC.getItem() {

            if item.hasChanged() {
            
                print(item)
                
                let updatedRows = database?.updateItem(item: item, rowId: item.getId()!)
                if updatedRows != 1 {
                    print("Problem updating row with\n\t\(item)")
                    return
                }
    
                sortDataByDate()
                myTableView.reloadData()
            }
            
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
        tableData.append(item2)
        
        let item3 = Item(title: "Use roast beef", date: date1!, type: Item.ItemType.BY, changed: false)
        tableData.append(item3)
        
        let item1 = Item(title: "Passport expires", date: date2!, type: Item.ItemType.ON, changed: false)
        tableData.append(item1)
  
     } // createData
    
    
    func sortDataByDate() {
        tableData.sort {
            $0.getDate() < $1.getDate()
        }
    } // sortDataByDate
    

    func dataFilePath() -> String {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:String?
        url = urls.first?.appendingPathComponent("itemsDB.plist").path
        return url!
        
    } // dataFilePath

}