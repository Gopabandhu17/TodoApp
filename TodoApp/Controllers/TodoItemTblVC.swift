//
//  TodoItemTblVC.swift
//  TodoApp
//
//  Created by Gopabandhu on 21/12/19.
//  Copyright © 2019 Gopabandhu. All rights reserved.
//

import UIKit
import CoreData

class TodoItemTblVC: UITableViewController {
    
    var arrItems = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category?{
        didSet{
            loadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            context.delete(arrItems[indexPath.row])
            arrItems.remove(at: indexPath.row)
            saveItems()
            tableView.reloadData()
        }
    }
    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "My TODO Item", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            
            let item = textField.text
            if let itemName = item{
                let newItem = Item(context: self.context)
                newItem.title = itemName
                newItem.isChecked = false
                newItem.parentCategory = self.selectedCategory
                self.arrItems.append(newItem)
                self.saveItems()
            }
        }))
        
        alert.addTextField { (txtField) in
            txtField.autocapitalizationType = UITextAutocapitalizationType.words
            textField = txtField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Supporting Methods
    func saveItems(){
        
        do{
            try context.save()
            loadData()
        }catch{
            print("Error while saving context \(error)")
        }
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name!)!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do{
            arrItems =  try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("Error While Fetching \(error)")
        }
    }
}

extension TodoItemTblVC: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.loadData()
            }
        }
    }
    
    
}
