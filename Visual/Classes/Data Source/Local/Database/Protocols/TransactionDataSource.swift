//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol TransactionDataSource {
    
    func findAll() throws -> [Transaction]

    func find(by req: WebTransactionRequest) throws -> [Transaction]

    func find(by id: Int) throws -> Transaction?
    
    func find(by ids: [Int]) throws -> [Transaction]
    
    func find(by identifiers: [Int64]) throws -> [Transaction]
    
    func find(by isSynced: Bool) throws -> [Transaction]
    
    func find(by keyword: String, _ dwType: Int) throws -> [Transaction]

    func find(by keywords: [String]) throws -> [Transaction]

    func findForApplyAll(by keywords: [String]) throws -> [Transaction]

    func save(_ elements: [Transaction]) throws

    func save(_ elements: Transaction) throws -> Int
    
    func edit(_ elements: [Transaction]) throws
    
    func remove(by ids: [Int]) throws
    
    func removeAll() throws


}

