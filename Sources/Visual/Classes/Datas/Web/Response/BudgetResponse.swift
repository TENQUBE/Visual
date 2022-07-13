//
//  File.swift
//  Visual
//
//  Created by tenqube on 28/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct BudgetResponse: Codable {
    
    let budget: Int
    
    init(budget: Int) {
        self.budget = budget
    }
    
}
