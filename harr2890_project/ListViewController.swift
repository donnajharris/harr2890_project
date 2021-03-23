//
//  ListViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-03-23.
//

import UIKit


class TableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!

}

class ListViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {
    
    let simpleTableIdentifier = "table_identifier"
    //    private let showSegueId = "ShowDetails"
    private let cellIdentifier = "ListViewReuseIdentifier"
    var tableData = [Item]() // the data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tableData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

            return cell! // return  the cell to the table view
    }
    
    
    // initialize the data source
    func createData() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date1 = formatter.date(from: "25/03/2021")
        let date2 = formatter.date(from: "22/09/2021")
        let date3 = formatter.date(from: "02/01/2022")


        let item2 = Item(title: "Credit card expires", date: date3!)
        tableData.append(item2)
        
        let item3 = Item(title: "Use roast beef", date: date1!) // changed order for sort
        tableData.append(item3)
        
        let item1 = Item(title: "Passport expires", date: date2!)
        tableData.append(item1)

        
//        let item1 = Item(title: "Use roast beef", date: date1!) // changed order for sort
//        tableData.append(item1)
//
//        let item2 = Item(title: "Passport expires", date: date2!)
//        tableData.append(item2)
//
//        let item3 = Item(title: "Credit card expires", date: date3!)
//        tableData.append(item3)
        
     } // createData
    
    func sortDataByDate() {
        tableData.sort {
            $0.getDate() < $1.getDate()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createData()
        sortDataByDate()
    }
}
