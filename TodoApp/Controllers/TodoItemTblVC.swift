//
//  TodoItemTblVC.swift
//  TodoApp
//
//  Created by Gopabandhu on 21/12/19.
//  Copyright © 2019 Gopabandhu. All rights reserved.
//

import UIKit

class TodoItemTblVC: UITableViewController {
    
    var arrItems = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrItems.count
    }
    
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellItemList", for: indexPath)
        cell.textLabel?.text = arrItems[indexPath.row].title
        cell.accessoryType = arrItems[indexPath.row].isChecked ? .checkmark : .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        arrItems[indexPath.row].isChecked = !arrItems[indexPath.row].isChecked
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        tableView.reloadData()
    }
    
    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "My TODO Item", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            
            let item = textField.text
            if let itemName = item{
                let newItem = Item()
                newItem.title = itemName
                self.arrItems.append(newItem)
                self.saveItems()
                self.tableView.reloadData()
            }
        }))
        
        alert.addTextField { (txtField) in
            
            textField = txtField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Supporting Methods
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(arrItems)
            if let path = dataFilePath{
                try data.write(to: path)
            }
        }catch{
            print("Error while encoding \(error)")
        }
    }
    
    func loadData(){
        
        let decoder = PropertyListDecoder()
        if let data = try? Data.init(contentsOf: dataFilePath!){
            do{
                arrItems = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error while decoding \(error)")
            }
        }
    }
}
