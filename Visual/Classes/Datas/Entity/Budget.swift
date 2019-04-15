//
//  UserCategory.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct Budget: DataProtocol {
    let id: Int
    let budget: Int
    let categoryCode: Int
    let date: Date

    
    init(_ param: BudgetParams) {
        
        self.id = param.id
        self.categoryCode = param.categoryCode
        self.budget = param.budget
        self.date = param.date
        
    }
    
    func checkParams() throws {
        
    }
}
