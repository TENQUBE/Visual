//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//


import Foundation
public struct Transaction: DataProtocol {
    
    let id: Int
    
    let identifier: Int64
    
    let cardId: Int
    
    var userCategoryId: Int
    
    var companyId: Int
    
    var companyName: String
    
    var companyAddress: String
    
    var code: Int
    
    let spentDate:  Date
    
    let finishDate: Date
    
    let lat: Double
    
    let lng: Double
    
    let spentMoney: Double
    
    let oriSpentMoney: Double
    
    let installmentCnt: Int
    
    let keyword: String
    
    let searchKeyword: String
    
    let repeatType: Int
    
    let currency: String
    
    var isDeleted: Bool
    
    let dwType: Int
    
    let fullSms: String?
    
    let smsDate: Date?
    
    let smsType: Int
    
    let regId: Int
    
    let isOffset: Bool
    
    let isCustom: Bool
    
    let isUserUpdate: Bool
    
    let isUpdateAll: Bool
    
    let memo: String
    
    var classCode: String
    
    var isSynced: Bool
    
    var isPopUpCompanyName: Bool
    
    init(_ param: TransactionParams) {
        
        self.id = param.id
        
        self.identifier = param.identifier
        
        self.cardId = param.cardId
        
        self.userCategoryId = param.userCategoryId
        
        self.companyId = param.companyId
        
        self.companyName = param.companyName
        
        self.companyAddress = param.companyAddress
        
        
        self.code = param.code
        
        self.spentDate = param.spentDate
        
        self.finishDate = param.finishDate
        
        self.lat = param.lat
        
        self.lng = param.lng
        
        self.spentMoney = param.spentMoney
        
        self.oriSpentMoney = param.oriSpentMoney
        
        self.installmentCnt = param.installmentCnt
        
        self.keyword = param.keyword
        
        self.searchKeyword = param.searchKeyword
        
        self.repeatType = param.repeatType
        
        self.currency = param.currency
        
        self.isDeleted = param.isDeleted
        
        self.dwType = param.dwType
        
        self.smsType = param.smsType
        
        self.fullSms = param.fullSms
        
        self.smsDate = param.smsDate
        
        self.regId = param.regId
        
        self.isOffset = param.isOffset
        
        self.isCustom = param.isCustom
        
        self.isUserUpdate = param.isUserUpdate
        
        self.isUpdateAll = param.isUpdateAll
        
        self.memo = param.memo
        
        self.classCode = param.classCode
        
        self.isSynced = param.isSynced
        
        
        self.isPopUpCompanyName = param.isPopUpCompanyName
        
    }
    
    func checkParams() throws {
        
    }
    
    func toRealmObj(realmManager: RealmManager?) throws -> TransactionModel {
        let model = TransactionModel()
        
        model.id = try realmManager?.incrementID(type: TransactionModel.self) ?? id
        
        model.identifier = identifier
        
        model.cardId = cardId
        
        model.userCategoryId = userCategoryId
        
        model.companyId = companyId
        
        model.companyName = companyName
        
        model.companyAddress = companyAddress
        
        model.code = code
        
        model.spentDate = spentDate
        
        model.finishDate = finishDate
        
        model.lat = lat
        
        model.lng = lng
        
        model.spentMoney = spentMoney
        
        model.oriSpentMoney = oriSpentMoney
        
        model.installmentCnt = installmentCnt
        
        model.keyword = keyword
        
        model.searchKeyword = searchKeyword
        
        model.repeatType = repeatType
        
        model.currency = currency
        
        model.isDeleted = isDeleted
        
        model.dwType = dwType
        
        model.smsType = smsType
        
        model.regId = regId
        
        model.isOffset = isOffset
        
        model.isCustom = isCustom
        
        model.isUserUpdate = isUserUpdate
        
        model.isUpdateAll = isUpdateAll
        
        model.memo = memo
        
        model.classCode = classCode
        
        model.isSynced = isSynced
        
        model.isPopUpCompanyName = isPopUpCompanyName
        
        return model
        
    }
    
    func toLcode() -> Int {
        return Int(String(code)[0..<2]) ?? 10
    }
    
    func toMcode() -> Int {
        return Int(String(code)[2..<4]) ?? 10
        
    }
    
}
