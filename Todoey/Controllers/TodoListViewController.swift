//
//  ViewController.swift
//  Todoey
//
//  Created by user  on 8/26/20.
//  Copyright © 2020 Jeff Coppage. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //let itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    // making it a VAR istead on a constant, (Making it mutable) so we can add items to it
    //var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    
    var itemArray = [Item()] // creating an array that holds things of type Item()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //let defaults = UserDefaults.standard // Using the singleton, standard UserDefaults(), of the UserDefaults Class

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath)
        
        
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
        
        loadItems()
        
        
        //Use IF statement because the list may not exist and we dont want it to crash
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{ // Getting the stored data located with key: "ToDoListArray"
//            itemArray = items
//        }
    }
    
    //MARK - Tableview Datasource Methods
    
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
    
    //MARK - TableView Delegate Methods
    
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//    self.addGestureRecognizer(tapGesture)
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //vvvvvvvvUSE THIS ISTEAD OF CODE BELOW THIS LINE, USES ALOT LESS CODE!!!vvvvvvvvv
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // SETS the value to the OPPOSITE, TRUE -> FALSE, FALSE -> TRUE
        
        //^^^^^^^^^^Instead use this above, ALOT LESS CODE!!^^^^^^^^^^
//        if(itemArray[indexPath.row].done == false) {
//            itemArray[indexPath.row].done = true
//        } else{
//            itemArray[indexPath.row].done = false
//        }
        
        saveItems()
        
        tableView.reloadData()
            
        
//        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            //what will happen once the user clicks the Add Item Button
            //print("Success!")
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //self.itemArray.append(textField.text!) // need to force unwrap it (!) because it may be NIL
            // you can also put: .append(textField.text ?? "New Item") if it is NIL then it'll replace the string with "New Item"
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray") //Storing the Array data in out app's default .plist file
            
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
    
    //MARK - Model Manupilation Methods
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding item array, \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        
       if let data = try? Data(contentsOf: dataFilePath!){ // the ? changes it to an optional, which means i have to use optional binding (if statement) to unwrap it safely
            let decoder = PropertyListDecoder()
        do{
        itemArray = try decoder.decode([Item].self, from: data)
        }catch{
            print("Error decoding item array, \(error)")
            }
        }


    }
}

