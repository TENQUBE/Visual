//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation


protocol UserCategoryDataSource {
    
    func createData(lcodes: [Int]) throws
    
    func findAll() throws -> [UserCategory]
    
    func find(by isExcept: Bool) throws -> [UserCategory]
    
    func find(by ids: [Int]) throws -> [UserCategory]
    
    func find(by id: Int) throws -> [UserCategory]

    func findByCode(code: Int) throws -> UserCategory?

    func save(_ elements: [UserCategory]) throws
    
    func removeAll() throws

}


