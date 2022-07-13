//
//  BudgetRequest.swift
//  Visual
//
//  Created by tenqube on 02/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct LogRequest: Codable, DataProtocol {
    
    
    let eventName: String
    let attributes: [Attribute]
    
    func checkParams() throws {
       
        if eventName.isEmpty {
            throw ParameterError.invalidValue(type: "parameter", name: "eventName is Empty \(eventName)")
        }
        
    }
    
    func toDictionary() -> [String: String] {
        
        var dict:[String: String] = [String: String]()
        
        for attr in attributes {
            dict[attr.key] = attr.value
        }
        return dict
    }
    
}

struct Attribute: Codable {
    let key: String
    let value: String
    
}


