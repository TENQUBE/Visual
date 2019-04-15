//
//  TransactionResopnse.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import Foundation
struct TransactionResponse: Codable {
    let transactions: [TransactionInfo]
    
    init(transactions: [TransactionInfo]) {
        self.transactions = transactions
    }
}

struct TransactionInfo: Codable {
    let transactionId: Int
    let categoryCode: Int
    let largeCategory: String
    let mediumCategory: String
    let userCateConfigId: Int
    let companyId: Int
    let franchise: String
    let cardId: Int
    let changeName: String
    let spentMoney: Double
    let installmentCount: Int
    let repeatType: Int
    let exceptType: Int
    let dwType: Int
    let currency: String
    let isOffset: Int
    let spentDate: String
    let finishDate: String
    let keyword: String
    let memo: String
    
    init(transactionId: Int,
        categoryCode: Int,
        largeCategory: String,
        mediumCategory: String,
        userCateConfigId: Int,
        companyId: Int,
        franchise: String,
        cardId: Int,
        changeName: String,
        spentMoney: Double,
        installmentCount: Int,
        repeatType: Int,
        exceptType: Int,
        dwType: Int,
        currency: String,
        isOffset: Int,
        spentDate: String,
        finishDate: String,
        keyword: String,
        memo: String) {
        
        self.transactionId = transactionId
        self.categoryCode = categoryCode
        self.largeCategory = largeCategory
        self.mediumCategory = mediumCategory
        self.userCateConfigId = userCateConfigId
        self.companyId = companyId
        self.franchise = franchise
        self.cardId = cardId
        self.changeName = changeName
        self.spentMoney = spentMoney
        self.installmentCount = installmentCount
        self.repeatType = repeatType
        self.exceptType = exceptType
        self.dwType = dwType
        self.currency = currency
        self.isOffset = isOffset
        self.spentDate = spentDate
        self.finishDate = finishDate
        self.keyword = keyword
        self.memo = memo
        
    }
    
    
}
