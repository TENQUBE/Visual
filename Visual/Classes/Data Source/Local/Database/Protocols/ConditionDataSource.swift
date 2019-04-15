//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol ConditionDataSource {
     
    func findAll() throws -> [Condition]
    
    func save(_ elements: [Condition]) throws
    
    func edit(_ elements: [Condition]) throws
    
}
