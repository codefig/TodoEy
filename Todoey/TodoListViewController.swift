//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
//    var ItemsArray : [Item] = []
    var ItemsArray = [Item]()
    let defaults = UserDefaults.standard

    let filePath = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let item1 = Item(title: "First Item", done: false)
        let item2 = Item(title: "First Item", done: true)
        let item3 = Item(title: "First Item", done: false)
        
        ItemsArray.append(item1)
        ItemsArray.append(item2)
        ItemsArray.append(item3)
        if let items = defaults.array(forKey: "TodoList")  as? [Item] {
            ItemsArray = items
        }
        
        print(filePath)
        loadSavedEncoded()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = ItemsArray[indexPath.row].title
        
        //fix for the marking or not
        if ItemsArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add new Todo", message: "Kindly add new todo", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) {
            (action) in
            let tempItem = Item(title: textField.text!, done: false)
//            self.ItemsArray.append(Item(title: textField.text!, done: false))
            self.ItemsArray.append(tempItem)
            
            // not using the userDefaults for custom item again because of the exception
//            self.defaults.set(self.ItemsArray, forKey: "TodoList")
            
            self.saveEncodedData()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        
        alertController.addAction(action)
        
        //to add a textField to the alertController
        alertController.addTextField{ (alertTextField) in
            alertTextField.placeholder = "New Item name"
            textField = alertTextField
        }
        present(alertController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ItemsArray[indexPath.row])
        if ItemsArray[indexPath.row].done == false {
            ItemsArray[indexPath.row].done = true
        }else{
            ItemsArray[indexPath.row].done = false
        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        saveEncodedData()
    }
    
    func saveEncodedData() {
        let encoder = PropertyListEncoder()
        do{
            let encodedItem =  try encoder.encode(self.ItemsArray)
            try encodedItem.write(to: self.filePath!)
        }
        catch {
            print("Error encoding file \(error)")
        }
        
    }
    
    func loadSavedEncoded() {
        let decoder = PropertyListDecoder()
        
        do {
            
//            let data = try Data(from: filePath as! Decoder)
            let data = try Data(contentsOf: filePath!)
            try ItemsArray = decoder.decode([Item].self, from: data)
        }
        catch {
            
        }
    }

}


struct Constants {
    
    static var cellIdentifier = "TodoItemCell"
}

