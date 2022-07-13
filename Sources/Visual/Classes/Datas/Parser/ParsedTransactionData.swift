//
//  File.swift
//  Visual
//
//  Created by tenqube on 07/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

public struct ParsedTransactionData {
    // TODO: cardName 다 있어야함
    // isOffset 상쇄여부
    // isDuplicate는 항상 0일듯

    
    let regRuleId: Int
    let cardName: String
    let cardNum: String
    let cardType: Int
    let cardSubType: Int
    let cardBalance: Double
    let spentMoney: Double
    let oriSpentMoney: Double
    
    let spentDate: String
    let installmentCount: Int
    let keyword: String
    let dwType: Int
    let currency: String
    let finishDate: String
    let identifier: String
    let isOffSet: Int
    let isDuplicate: Int
    let memo: String
    let spentLatitude: Double
    let spentLongitude: Double
    let isSuccess: Int
    let isCurrentTran: Bool
    let categoryCode: Int
    let companyId: Int
    let companyName: String
    let companyAddress: String
    let classCode: String
    let isPopUpCompanyName: Bool
    let fullSms: String
    
    
}
