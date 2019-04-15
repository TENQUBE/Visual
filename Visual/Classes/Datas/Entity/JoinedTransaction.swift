//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct JoinedTransaction: DataProtocol {
    
    let transaction: Transaction

    let card: Card
    
    let userCate: UserCategory

    let category: Category
    
    init(transaction: Transaction, card: Card, userCate: UserCategory, category: Category) {
    
        self.transaction = transaction
        self.card = card
        self.userCate = userCate
        self.category = category
     
    }
    
    func checkParams() throws {
        
    }
}
