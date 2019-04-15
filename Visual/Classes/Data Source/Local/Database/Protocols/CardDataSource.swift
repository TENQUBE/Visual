//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol CardDataSource {
    
    func findAll() throws -> [Card]
    
    func find(by id: Int) throws -> Card?

    func find(by name: String, _ type: Int, _ subType: Int, balance: Double) throws -> Card
    
    func find(by cardIds: [Int]) throws -> [Card]
    
    func find(by isExcept: Bool) throws -> [Card]
    
    func save(_ elements: [Card]) throws
    
    func removeAll() throws
}
