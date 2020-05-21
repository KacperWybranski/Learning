//
//  Country.swift
//  Challenge4
//
//  Created by test on 21/05/2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class Country: Codable {
    var name: String
    var capital: String
    
    init(name: String, capital: String) {
        self.name = name
        self.capital = capital
    }
}
