//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol BudgetDataSource {
    
    func findAll() throws -> [Budget]
    
    func save(_ elements: [Budget]) throws
    
    func removeAll() throws
}
