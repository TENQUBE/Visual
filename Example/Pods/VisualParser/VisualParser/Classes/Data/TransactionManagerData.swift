//
//  TransactionManagerData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

struct TransactionManagerData {
    let identifier: String
    let cardId: String
    let cardType: Int
    let spentMoney: Double
    let spentDate: Date
    let installmentCount: Int
    let keyword: String
    let dwType: Int
    let isCancel: Int
    let categoryCode: Int

    init(_ params: TransactionManagerParams) {
        identifier = params.identifier
        cardId = params.cardId
        cardType = params.cardType
        spentMoney = params.spentMoney
        spentDate = params.spentDate.toDate()!
        installmentCount = params.installmentCount
        keyword = params.keyword
        dwType = params.dwType
        isCancel = params.isCancel
        categoryCode = params.categoryCode
    }
}
