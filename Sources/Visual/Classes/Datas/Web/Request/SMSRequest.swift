//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct SMSRequest: Codable, DataProtocol {
    
    let text: String
    let callbackJS: String
    
    init (text: String, callbackJS: String) {
        self.text = text
        self.callbackJS = callbackJS
    }

    func checkParams() throws {
        
        if text.isEmpty {
            throw ParameterError.invalidValue(type: "text is empty", name: "text error \(self.text)")
            
        }
        
    }
}
