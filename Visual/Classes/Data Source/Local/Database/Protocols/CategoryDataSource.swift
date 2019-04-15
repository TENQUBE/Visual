//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol CategoryDataSource {
    
    func findDistinctLocdes() throws -> [Int]
    
    func findAll() throws -> [Category]
    
    func find(by codes: [Int]) throws -> [Category]
    
    func find(by code: Int) throws -> Category?
    
    func save(_ elements: [Category]) throws
    
    func edit(_ elements: [Category]) throws
    
    func remove(_ elements: [Category]) throws
}
