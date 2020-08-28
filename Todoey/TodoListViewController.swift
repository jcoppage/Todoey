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
    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Use IF statement because the list may not exist and we dont want it to crash
        if let items = defaults.array(forKey: "TodoListArray") as? [String]{ // Getting the stored data locted with key: "ToDoListArray"
            itemArray = items
        }
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    
//    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//    self.addGestureRecognizer(tapGesture)
    
    @objc func tableViewTapped(){
        //messageTextfield.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            //what will happen once the user clicks the Add Item Button
            //print("Success!")
            
            self.itemArray.append(textField.text!) // need to force unwrap it (!) because it may be NIL
            // you can also put: .append(textField.text ?? "New Item") if it is NIL then it'll replace the string with "New Item"
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray") //Stroing the Array data in out app's .p list file
            
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    


}

