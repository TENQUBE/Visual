//
//  BudgetRequest.swift
//  Visual
//
//  Created by tenqube on 02/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct AddPaymentRequest: Codable, DataProtocol {
    
    let name: String
    
    let type: Int
    
    let callbackJS: String
    
    init (name: String, type: Int, callbackJS: String) {
        
        self.name = name
        self.type = type
        self.callbackJS = callbackJS
    }
    
    func checkParams() throws {
        
        
        
    }
    
    
}


