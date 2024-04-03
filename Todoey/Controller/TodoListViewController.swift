import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    
    //MARK: - TableView Data
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        writeData()
    }
    
    
    //MARK: - Add ToDo Item Pressed
    
    @IBAction func addToKeyPressed(_ sender:Any) {
        
        var textInput = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Item(context: self.context)
            if let text = textInput.text {
                item.title = text
            }
            self.itemArray.append(item)
            self.writeData()
            
        }
        
        alert.addTextField { textfield in
            textfield.placeholder = "Type Item"
            textInput = textfield
        }
        
        alert.addAction(add)
        present(alert, animated: true, completion: nil)
    }
    
    func writeData(){
        do{
            try context.save()
        } catch {
            print("Error saving data in Context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do{
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Delegate

extension TodoListViewController:
    UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async{
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadData()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }else {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadData(with: request)
            tableView.reloadData()
        }
    }
}

