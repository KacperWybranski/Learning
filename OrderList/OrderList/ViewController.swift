//
//  ViewController.swift
//  OrderList
//
//  Created by test on 21/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var allTables = [RestaurantTable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "OrderList"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTable))
        
        let defaults = UserDefaults.standard
        if let savedTables = defaults.object(forKey: "allTables") as? Data {
            if let decodedTables = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTables) as? [RestaurantTable] {
                allTables = decodedTables
            }
        } else {
            for i in 0..<3 {
                let newTable = RestaurantTable(name: "Table \(i+1)")
                allTables.append(newTable)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTable", for: indexPath)
        cell.textLabel?.text = allTables[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTables.count
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Certain") as? CertainTableViewController else { return }
        vc.tableNumber = indexPath.row
        vc.title = allTables[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addNewTable() {
        let newNumber = allTables.count+1
        
        let ac = UIAlertController(title: "Add new table", message: "Enter the name", preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].placeholder = "Table \(newNumber)"
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, weak self] _ in
            guard let readenText = ac?.textFields?[0].text else { return }
            var tableName = ""
            
            if readenText == "" {
                tableName = "Table \(newNumber)"
            } else {
                tableName = readenText
            }
            
            self?.allTables.append(RestaurantTable(name: tableName))
            self?.tableView.reloadData()
            self?.save()
        })
        ac.addAction(UIAlertAction(title: "Return", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: allTables, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "allTables")
        }
    }


}

