//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct ConfirmBoxRequest: Codable, DataProtocol {
    
    let message: String
    let data: [ConfirmBox]
    
    func checkParams() throws {
        
        
    }
}

struct ConfirmBox: Codable {
    let buttonText: String
    let callbackJS: String
    
    
    
}
