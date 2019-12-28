//
//  CategoryTblVC.swift
//  TodoApp
//
//  Created by Gopabandhu on 28/12/19.
//  Copyright © 2019 Gopabandhu. All rights reserved.
//

import UIKit
import CoreData

class CategoryTblVC: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arrCategory = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrCategory.count
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCategoryList", for: indexPath)
        cell.textLabel?.text = arrCategory[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! TodoItemTblVC
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
            vc.selectedCategory = arrCategory[indexPath.row]
        }
    }
    
    //MARK:- Supporting Methods
    
    @IBAction func btnPlus(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            
            if let text = textField.text{
                
                let newCategory = Category(context: self.context)
                newCategory.name = text
                self.arrCategory.append(newCategory)
                self.saveData()
            }
            
//            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addTextField { (txtField) in
            txtField.placeholder = "Enter Category"
            textField = txtField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(){
        
        do{
            try context.save()
            loadData()
        }catch{
            print("Error in saving data \(error)")
        }
    }
    
    func loadData(){
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do{
            arrCategory = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("Error while fetching \(error)")
        }
    }
}
