//
//  Order.swift
//  OrderList
//
//  Created by test on 21/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class Order: NSObject, NSCoding {
    var name: String
    var value: Int
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(value, forKey: "value")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        value = coder.decodeObject(forKey: "value") as? Int ?? 0
    }
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}
