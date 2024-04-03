//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Aman Giri on 2024-04-02.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    
    @IBAction func addCategoryPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var textInput = UITextField()
        
        let add = UIAlertAction(title:"Add", style:.default) { action in
            let category = Category(context: self.context)
            if let input = textInput.text {
                category.name = input
                self.categoryArray.append(category)
                self.writeData()
            }
        }
        
        alert.addTextField(){ textfield in
            textfield.placeholder = "Enter Category"
            textInput = textfield
        }
        
        alert.addAction(add)
        present(alert, animated: true, completion: nil)
    }
    
    func writeData() {
        do{
            try context.save()
        } catch {
           print ("Error saving data to context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            let categoryData = try context.fetch(request)
            categoryArray = categoryData
            tableView.reloadData()
        }catch {
            print("Error loading data from context", error)
        }
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
