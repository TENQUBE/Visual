//
//  TypeAliases.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

public typealias FullSms = String

public typealias RegRuleParams = (
    regId: Int?,
    repSender: String?,
    regExpression: String?,
    cardName: String?,
    cardType: String?,
    cardSubType: String?,
    cardNum: String?,
    spentMoney: String?,
    spentDate: String?,
    keyword: String?,
    installmentCount: String?,
    dwType: String?,
    isCancel: String?,
    currency: String?,
    balance: String?,
    userName: String?,
    smsType: Int?,
    isDelete: Int?,
    priority: Int?
)

public typealias SenderParams = (
    senderId: Int?,
    smsType: Int?,
    sender: String?,
    repSender: String?,
    isDelete: Int?
)

public typealias RepSenderNameParams = (
    id: Int?,
    repSender: String?,
    sender: String?,
    isDelete: Int?
)

public typealias SearchCompanyResponseParams = (
    id: String,
    oriKeyword: String,
    searchKeyword: String,
    companyId: Int,
    companyName: String,
    companyAddress: String,
    categoryCode: Int,
    classCode: String,
    isPopUpCompanyName: Bool
)

typealias TransactionParams = (
    cardId: Int,
    cardType: Int,
    smsId: Int,
    fullSms: String,
    smsDate: String,
    smsType: Int,
    regRuleId: Int,
    spentLatitude: Double,
    spentLongitude: Double,
    spentMoney: Double,
    spentDate: String,
    installmentCount: Int,
    keyword: String,
    dwType: Int,
    currency: String,
    finishDate: String,
    identifier: String,
    isOffSet: Int,
    isDuplicate: Int,
    memo: String,
    categoryCode: Int
)


typealias CardParams = (
    name: String,
    num: String,
    type: Int,
    subType: Int,
    balance: Double
)

typealias SenderRegRulesDict = [String: [RegRuleData]]

typealias SenderRegRuleDict = [String: RegRuleData]

typealias ParsingResult = (key: String, value: Int)

typealias RepSenderNameDict = [String: [String]]

typealias TransactionManagerParams = (
    identifier: String,
    cardId: String,
    cardType: Int,
    spentMoney: Double,
    spentDate: String,
    installmentCount: Int,
    keyword: String,
    dwType: Int,
    isCancel: Int,
    categoryCode: Int
)

typealias TransactionExtDataParams = (
    regRuleId: Int,
    spentMoney: Double,
    spentDate: String,
    installmentCount: Int,
    keyword: String,
    dwType: Int,
    currency: String,
    userName: String,
    isCancel: Bool
)
