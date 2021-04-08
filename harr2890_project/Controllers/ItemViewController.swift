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
    
    private var item : Item?
    
    func getItem() -> Item? {
        return self.item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        
        nameField.text = item?.getTitle()
        typeField.text = ItemHelper.getTypeString(item: item!)
        dateField.text = item?.getDateString()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initWithItem(item: Item) {
        self.item = item
        
        print("initWithItem")
        print(item)
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

            print("Changed after edit")
            print(changedItem)
            
            print("compared to item")
            print(item!)
            
            if item!.hasChanged() {
            
                // Update item on display
                nameField.text = changedItem.getTitle()
                typeField.text = ItemHelper.getTypeString(item: changedItem)
                dateField.text = changedItem.getDateString()
                
                // Prepare to update on return to list table view
                item = changedItem
            }
        }
    } // unwindToItemList
    
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // return point after clicking Cancel on edit view
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue){

    }

}
