//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct DateRequest: Codable, DataProtocol {
    
    let date: String
    let callbackJS: String
    
    init (date: String, callbackJS: String) {
        self.date = date
        self.callbackJS = callbackJS
    }

    func checkParams() throws {
        if self.date.toYMD() == nil {
            throw ParameterError.invalidValue(type: "date error", name: "date")
        }
    }
}
