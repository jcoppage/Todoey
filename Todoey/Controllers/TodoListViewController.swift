//
//  ViewController.swift
//  Todoey
//
//  Created by user  on 8/26/20.
//  Copyright © 2020 Jeff Coppage. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController { // Got rid of (UISearchBarDelegate,) because we are adding an Extension at the bottom aoutside the Class declaration
    
    //let itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    // making it a VAR istead on a constant, (Making it mutable) so we can add items to it
    //var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    
    var itemArray = [Item]() // creating an array that holds things of type Item()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
    
    var selectedCategory : Category? { // ? because its going to be nil until we set it a value
        didSet{ // Once selectedCategory gets set a value
            loadItems()
        }
    }
    
    // vvvvvvvvvv This is how we create a reference (Singleton Object) to our AppDelegate!!!!!! vvvvvvvvvv
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //^^^^^^^^ moving this line of code up here to make it a shared constant^^^^^^^^^
    
    //vvvvvvv Don't need to manually addthis in order to set it as a delegate, we just set the searchBar as the delegate ourselves in Main.storyboard vvvvvvvvv
    
    //@IBOutlet weak var searchBar: UISearchBar!
    
    //^^^^^^^ Don't need to manually addthis in order to set it as a delegate, we just set the searchBar as the delegate ourselves in Main.storyboard^^^^^^^^^^^^
    
    //let defaults = UserDefaults.standard // Using the singleton, standard UserDefaults(), of the UserDefaults Class

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath)
        
        //vvvv Dont need to manually do this, we just set the searchBar as the delegate ourselves in the Main.stoaryboard vvvvvvvvvv
        
        //searchBar.delegate = self
        
        //^^^^^^^^^Dont need to manually do this, we just set the searchBar as the delegate ourselves in the Main.stoaryboard ^^^^^^^^
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggs"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        //vvvvvvvvv deleting loadItems() below because it gets called when the Segue is performd by setting the 'selectedCategory' a value and once selectedCategory gets set a value loadItems() gets called, and that has to happen in order to get to this ViewController vvvvvvvvv
        
//        loadItems()
        
        //^^^^^^^^^ deleting loadItems() above because it gets called when the Segue is performd by setting the 'selectedCategory' a value and once selectedCategory gets set a value loadItems() gets called, and that has to happen in order to get to this ViewController ^^^^^^^^
        
        
        //Use IF statement because the list may not exist and we dont want it to crash
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{ // Getting the stored data located with key: "ToDoListArray"
//            itemArray = items
//        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // vvvvvv Can't add cells this way because it will be delteed and created again with missing information when scrolling up and dwon the TableView.
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //cell.textLabel?.text = itemArray[indexPath.row].title
        cell.textLabel?.text = item.title
        
        //cell.accersoryType = item.done == true ? .checkmark : .none
        
        //vvvvvvvvvvvv OR An even shorter way than ^^^^^^^^^^^
        
        cell.accessoryType = item.done ? .checkmark : .none // Using the TERNARY OPERATOR
        
        //^^^^^^^^^ The top line of code is the shorter way/version of the bottom line of code vvvvvvvvvvvvvvv
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else{
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return itemArray.count

    }
    
    //MARK: - TableView Delegate Methods
    
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//    self.addGestureRecognizer(tapGesture)
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //vvvvvvvv USE THIS INSTEAD OF CODE ABOVE ^^^^^^^ THIS LINE, USES ALOT LESS CODE!!!vvvvvvvvv
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // SETS the value to the OPPOSITE, TRUE -> FALSE, FALSE -> TRUE
        
        //^^^^^^^^^^Instead use this above, ALOT LESS CODE!!^^^^^^^^^^
        
        //vvvvvv Below is a way to UPDATE (crUd) the "title" attribute (or Field)(or Property) vvvvvvvv
        
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //^^^^^^^^^^Above is a way to UPDATE (crUd the "title" attribute (or Field)(or Property)^^^^^^^^
        
        //vvvvvv Below is the DELETE part of (cruD).  Has to be in this order!!!vvvvvvvvvv
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //^^^^^^^Below is the DELETE part of (cruD).  Has to be in this order!!!^^^^^^^
        
//        if(itemArray[indexPath.row].done == false) {
//            itemArray[indexPath.row].done = true
//        } else{
//            itemArray[indexPath.row].done = false
//        }
        
        saveItems()
        
        //tableView.reloadData()
            
        
//        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            //what will happen once the user clicks the Add Item Button
            //print("Success!")
            
            //let newItem = Item()
            
            // vvvvvvv This is how we create a reference (Singleton Object) to our AppDelegate!!!!!!vvvvvvvvvvvvv
            
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // ^^^^^^^^ moving the above line of code up on top to make it a shared constant ^^^^^^^^^^^^^
            
            //^^^^^^^^ added to
            
            let newItem = Item(context: self.context) // CREATES ((C)rud) an NSMangedObject of type: Item inside our context named: context.  So, we are creating data in our temporary context so we can later save (or commit) that data (context.save()) from that context into our persistant container (database). We use self. because we are inside a CLOSURE at the moment
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
//            self.itemArray.append(textField.text!) // need to force unwrap it (!) because it may be NIL
            // you can also put: .append(textField.text ?? "New Item") if it is NIL then it'll replace the string with "New Item"
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray") //Storing the Array data in out app's default .plist file
            
            self.saveItems() // <-- vvvvv Put the below code into a function to clean it up vvvvvvvvv
            
//            let encoder = PropertyListEncoder()
//
//            do{
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            } catch{
//                print("Error encoding item array, \(error)")
//            }
//
//
//            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupilation Methods
    
    func saveItems(){
        
//        let encoder = PropertyListEncoder()
//
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        } catch{
//            print("Error encoding item array, \(error)")
//        }
        
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    
    //vvvvvvvv Reading items (c(R)ud) from our database vvvvvvvvvv
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){ // 'with' is our external parameter, 'request' is our internal parameter
        
        //vvvvvv trying to retrieve (Our Output) an array of Objects of  type: Item that is stored in our persistant container vvvvv
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate { // making sure it is not NIL
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        request.predicate = compoundPredicate
        
        do{
            itemArray = try context.fetch(request)
        } catch{
            print("error fetching data from context \(error)")
        }
        
        tableView.reloadData()
   
    }
    
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//    }
    
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate{ // Extending the functionality of our
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
       let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       print(searchBar.text!)
        
       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
       request.predicate = predicate
        
       
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // .sortDescriptors expects an array, so we add [] brackets
        
        loadItems(with: request, predicate: predicate )
        
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//                print("Error fetching data from context \(error)")
//            }
        
//        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        print(searchBar.text!)
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // .sortDescriptors expects an array, so we add [] brackets
        
        loadItems(with: request)
        if searchBar.text?.count == 0 {
            loadItems()
            
            
            DispatchQueue.main.async{ // Asking it to grab us the MAIN Thread, which is where we should be updating our User Interface elements. The DespatchQueue manager that assigns projects (tasks) to different threads. .main is our main thread.
                
                searchBar.resignFirstResponder() //Running this method on the MAIN Queue (Main Thread)

            }
        }
    }
    
    
}

