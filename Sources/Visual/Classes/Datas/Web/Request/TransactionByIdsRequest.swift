//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct TransactionByIdsRequest: Codable, DataProtocol {
    
    let tranIds: [Int]
    let callbackJS: String
    
    init(tranIds: [Int], callbackJS: String) {
        self.tranIds = tranIds
        self.callbackJS = callbackJS
 
    }

    func checkParams() throws {
        if tranIds.count == 0 {
            throw ParameterError.invalidValue(type: "ids is empty", name: "\(self.tranIds))")
        }
    }
}
