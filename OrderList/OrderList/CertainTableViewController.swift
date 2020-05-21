//
//  CertainTableViewController.swift
//  OrderList
//
//  Created by test on 21/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class CertainTableViewController: UITableViewController {
    var allTables = [RestaurantTable]()
    var allOrders = [Order]() {
        didSet {
            allTables[tableNumber].ordersForThisTable = allOrders
            save()
        }
    }
    var tableNumber = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if let savedTables = defaults.object(forKey: "allTables") as? Data {
            if let decodedTables = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTables) as? [RestaurantTable] {
                allTables = decodedTables
                allOrders = allTables[tableNumber].ordersForThisTable
            }
        }
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewOrder))
        let clearBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearOrders))
        clearBtn.tintColor = UIColor.systemRed
        navigationItem.rightBarButtonItems = [addBtn, clearBtn]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        cell.textLabel?.text = allOrders[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allOrders.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "What do you want to do with this order?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.allOrders.remove(at: indexPath.row)
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }

    @objc func addNewOrder() {
        let ac = UIAlertController(title: "Add new order", message: "Enter the name", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak ac, weak self] _ in
            guard let orderName = ac?.textFields?[0].text else { return }
            if orderName == "" { return }
            self?.allOrders.append(Order(name: orderName, value: nil))
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: allTables, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "allTables")
        }
    }
    
    @objc func clearOrders() {
        let ac = UIAlertController(title: "Remove all orders from this table", message: "Are you sure you want it?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes", style: .destructive){ [weak self] _ in
            self?.allOrders.removeAll()
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }
}
