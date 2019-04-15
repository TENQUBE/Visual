//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol ContentDataSource {
    
    func findAll() throws -> [Content]
    
    func save(_ elements: [Content]) throws
    
    func edit(_ elements: [Content]) throws 
    
}
