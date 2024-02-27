//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    // Define list of items for table display
    var itemArray = [CellItem]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // view did load function, there by default
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
    }
    
    //MARK - Tableview DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what happens when the add item is clicked
            
            let newItem = CellItem()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
                
        alert.addAction(action)
        
        
        
        present(alert, animated: true, completion: nil)
    }
    
    // this method allows you to save items intem the plist database by using the propertyencoder
    
    //we are encoding our data into something that can be saved into a plist form here to be stored
    func saveItems() {
        //instantialize the encoder
        let encoder = PropertyListEncoder()
        //wrap it in a do catch to make sure it works
        do {
            //let it try to encode the data and save to the data variable if it works
            let data = try encoder.encode(itemArray)
            //try to write it to the database
            try data.write(to: dataFilePath!)
        //if any of these steps fail then print an error
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //we are decoding our data from a format of the plist into an array of CellItem
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([CellItem].self, from: data)
            } catch {
                print("Error decoding data \(error)")
            }
            
        }
    }
}

