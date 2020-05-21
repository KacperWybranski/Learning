//
//  RestaurantTable.swift
//  OrderList
//
//  Created by test on 21/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class RestaurantTable: NSObject, NSCoding {
    var name: String
    var ordersForThisTable = [Order]()
    var billValue: Int = 0
    
    
    init(name: String) {
        self.name = name
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(ordersForThisTable, forKey: "ordersForThisTable")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        ordersForThisTable = coder.decodeObject(forKey: "ordersForThisTable") as? [Order] ?? [Order]()
    }
}
