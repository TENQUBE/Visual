//
//  DeleteTranRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct DeleteTransaction: Codable, DataProtocol {
    
    let ids: [Int]
    let callbackJS: String
    
    func checkParams() throws {
        
        if ids.count == 0 {
            throw ParameterError.invalidValue(type: "ids is empty", name: "\(self.ids))")
        }
    }
    
    
}
