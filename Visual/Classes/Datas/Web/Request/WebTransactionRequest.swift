//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct WebTransactionRequest: Codable, DataProtocol {
    
    let year: Int
    let month: Int
    let before: Int
    let callbackJS: String
    
    init(year: Int, month: Int, before: Int, callbackJS: String) {
        self.year = year
        self.month = month
        self.before = before
        self.callbackJS = callbackJS
    }
//    var dwType: Int
//    var exceptType: Int
//    
    func checkParams() throws {
        if year < 2000 {
            throw ParameterError.invalidValue(type: "year error", name: "year < 2000")
        
        }
        
        if month < 0 || month > 12 {
            throw ParameterError.invalidValue(type: "month error", name: "month < 0 || month > 12")
        }
        
        
        
    }
}
