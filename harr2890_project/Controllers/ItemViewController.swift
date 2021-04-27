//
//  ItemViewController.swift
//  harr2890_project
//
//  Created by Donna Harris on 2021-04-06.
//

import UIKit

class ItemViewController: UIViewController {

    let segueID = "EditItem"
    
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var typeField: UILabel!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryNameField: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationCoordinatesField: UILabel!
    
    private var item : Item?
    
    func getItem() -> Item? {
        return self.item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        let helper = ItemHelper()
        
        nameField.text = item?.getTitle()
        typeField.text = helper.getTypeString(item: item!)
        dateField.text = item?.getDateString()
        
        if let categoryName = item?.getCategory()?.getName() {
            categoryNameField.text = categoryName
        } else {
            categoryLabel.text = ""
            categoryNameField.text = "" // display nothing
        }
        
        if let coordinatesString = item?.getLocationStringToDisplay() {
            if coordinatesString.starts(with: "Lat") {
                locationCoordinatesField.text = coordinatesString
            } else {
                locationLabel.text = ""
                locationCoordinatesField.text = "" // display nothing
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initWithItem(item: Item) {
        self.item = item
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
                
        if segue.identifier == segueID {
            let vc = segue.destination as! EditItemViewController
            vc.editItem(item: self.item!)
        }
        
    } // prepare segue
    
    
    @IBAction func unwindToView(sender: UIStoryboardSegue) {
        
        if let vc = sender.source as? EditItemViewController,
           let changedItem = vc.getChangedItem() {
            
            let helper = ItemHelper()

                // Update item on VIEW display
                nameField.text = changedItem.getTitle()
                typeField.text = helper.getTypeString(item: changedItem)
                dateField.text = changedItem.getDateString()
            
                if let categoryName = changedItem.getCategory()?.getName() {
                    categoryNameField.text = categoryName
                } else {
                    categoryLabel.text = ""
                    categoryNameField.text = "" // display nothing
                }
                
                let coordinatesString = changedItem.getLocationStringToDisplay()
            
                if coordinatesString.starts(with: "Lat") {
                    locationCoordinatesField.text = coordinatesString
                } else {
                    locationLabel.text = ""
                    locationCoordinatesField.text = "" // display nothing
                }
            
                // Prepare to update on return to list table view
                item = changedItem
            }
        else {
            item = nil
            print("Error: Unexpected error returning from item edit.")
        }
    
    } // unwindToItemList
    
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // return point after clicking Cancel on edit view
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue){

    }

}
