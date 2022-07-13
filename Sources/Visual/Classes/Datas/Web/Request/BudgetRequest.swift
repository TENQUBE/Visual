//
//  BudgetRequest.swift
//  Visual
//
//  Created by tenqube on 02/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct BudgetRequest: Codable, DataProtocol {
    
    
    let budget: Int
    let callbackJS: String
    
    init (budget: Int, callbackJS: String) {
        self.budget = budget
        self.callbackJS = callbackJS
    }
    
    func checkParams() throws {
       
        
    }
    
    
}


