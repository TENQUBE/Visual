//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct TimeRequest: Codable, DataProtocol {
    
    let time: String // 22:22:22
    let callbackJS: String
    
    init (time: String, callbackJS: String) {
        self.time = time
        self.callbackJS = callbackJS
    }

    func checkParams() throws {
        
        if self.time.toTime() == nil {
            throw ParameterError.invalidValue(type: "time error", name: "time")
        }
    }
}
