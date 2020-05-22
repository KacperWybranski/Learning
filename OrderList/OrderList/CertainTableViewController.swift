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
    var allDishes = [String: Int]()
    
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
        let moreBtn = UIBarButtonItem(image: UIImage(systemName: "text.justify"), style: .plain, target: self, action: #selector(moreOptions))
        navigationItem.rightBarButtonItems = [addBtn, moreBtn]
        
        loadMenu()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        cell.textLabel?.text = allOrders[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
            
            let price = self?.allDishes[orderName] ?? 0
            
            self?.allOrders.append(Order(name: orderName, value: price))
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
    
    func clearOrders() {
        allOrders.removeAll()
        tableView.reloadData()
    }
    
    @objc func moreOptions() {
        let ac = UIAlertController(title: "More Options:", message: "What do you want to do?", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Create a bill", style: .default) { [weak self] _ in
            self?.sumAllOrders()
        })
        ac.addAction(UIAlertAction(title: "Clear the table", style: .destructive) { [weak self] _ in
            self?.clearOrders()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func sumAllOrders() {
        
        var bill = 0
        for order in allOrders {
            bill += order.value
        }
        let ac = UIAlertController(title: "To pay", message: "\(bill) $", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func loadMenu() {
        if let url = Bundle.main.url(forResource: "dishes", withExtension: "txt") {
            if let allLines = try? String(contentsOf: url) {
                let lines = allLines.components(separatedBy: "\n")
                for line in lines {
                    let bits = line.components(separatedBy: "|")
                    let dish: String = bits[0]
                    let price: Int = Int(bits[1]) ?? 0
                    allDishes.updateValue(price, forKey: dish)
                }
            }
        }
    }
}
