//
//  TransactionExtData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

public struct TransactionExtData {
    let regRuleId: Int
    let spentMoney: Double
    let spentDate: String
    let installmentCount: Int
    let keyword: String
    let dwType: Int
    let currency: String
    let userName: String
    let isCancel: Bool

    init(_ params: TransactionExtDataParams) {
        regRuleId = params.regRuleId
        spentMoney = params.spentMoney
        spentDate = params.spentDate
        installmentCount = params.installmentCount
        keyword = params.keyword
        dwType = params.dwType
        currency = params.currency
        userName = params.userName
        isCancel = params.isCancel
    }
}
