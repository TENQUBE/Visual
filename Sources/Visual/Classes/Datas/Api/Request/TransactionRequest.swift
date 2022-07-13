//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct TransactionRequest: Codable {
    
    let transactions: [ServerTransaction]
    
    init(transactions: [ServerTransaction]) {
        self.transactions = transactions
    }
}

struct ServerTransaction: Codable {
    let identifier: String
    let cardName : String
    let cardNum: String
    let cardType: Int
    let cardSubType: Int
    let spentMoney: Double
    let oriSpentMoney: Double
    let spentDate: String
    let finishDate: String
    let oriKeyword: String
    let searchKeyword: String
    let installmentCount: Int
    let dwType: Int
    let currency: String
    let balance: Double
    let sender: String
    let fullSms: String
    let smsDate: String
    let smsType: Int
    let isOffset: Int
    let isDuplicate: Int
    let memo: String
    let spentLatitude: Double
    let spentLongitude: Double
    let categoryCode: Int
    let companyId: Int
    let classCode: String
    let regId: Int
    
    let isCustom: Int
    let isUserUpdate: Int
    let isUpdateAll: Int
    let isDeleted: Int
    
    init(transaction: Transaction, card: Card) throws {
        self.identifier = String(transaction.identifier)
        
        let cards = Utill.splitCard(cardName: card.name)
        self.cardName = cards.0
        self.cardNum = cards.1
        self.cardType = card.type
        self.cardSubType = card.subType
        self.spentMoney = transaction.spentMoney
        self.oriSpentMoney = transaction.oriSpentMoney
        self.spentDate = transaction.spentDate.toStr()
        self.finishDate = transaction.finishDate.toStr()
        self.oriKeyword = transaction.keyword
        self.searchKeyword = transaction.searchKeyword
        self.installmentCount = transaction.installmentCnt
        self.dwType = transaction.dwType
        self.currency = transaction.currency
        self.balance = card.balance
        self.sender = "none"
        self.fullSms = transaction.fullSms ?? "none"
        self.smsDate = transaction.smsDate?.toStr() ?? "none"
        self.smsType = transaction.smsType
        self.isOffset = transaction.isOffset ? 1: 0
        self.isDuplicate = 0
        self.memo = transaction.memo
        self.spentLatitude = transaction.lat
        self.spentLongitude = transaction.lng
        self.categoryCode = transaction.code
        self.companyId = transaction.companyId
        self.classCode = transaction.classCode
        self.regId = transaction.regId
        
        self.isCustom = transaction.isCustom ? 1 : 0
        self.isUserUpdate = transaction.isUserUpdate ? 1: 0
        self.isUpdateAll = transaction.isUpdateAll ? 1: 0
        self.isDeleted = transaction.isDeleted ? 1: 0
        
    }
}
