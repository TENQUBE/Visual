//
//  RegRule.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct RegRuleData {
    public let regId: Int
    public let repSender: String
    public let regExpression: String
    public let cardName: String
    public let cardType: String
    public let cardSubType: String
    public let cardNum: String
    public let spentMoney: String
    public let spentDate: String
    public let keyword: String
    public let installmentCount: String
    public let dwType: String
    public let isCancel: String
    public let currency: String
    public let balance: String
    public let userName: String
    public let smsType: Int
    public let isDelete: Int
    public let priority: Int

    public init(_ regRuleParams: RegRuleParams) throws {
        try Validation.shared.validate(regRuleParams)

        self.regId = regRuleParams.regId!
        self.repSender = regRuleParams.repSender!
        self.regExpression = regRuleParams.regExpression!
        self.cardName = regRuleParams.cardName!
        self.cardType = regRuleParams.cardType!
        self.cardSubType = regRuleParams.cardSubType!
        self.cardNum = regRuleParams.cardNum!
        self.spentMoney = regRuleParams.spentMoney!
        self.spentDate = regRuleParams.spentDate!
        self.keyword = regRuleParams.keyword!
        self.installmentCount = regRuleParams.installmentCount!
        self.dwType = regRuleParams.dwType!
        self.isCancel = regRuleParams.isCancel!
        self.currency = regRuleParams.currency!
        self.balance = regRuleParams.balance!
        self.userName = regRuleParams.userName!
        self.smsType = regRuleParams.smsType!
        self.isDelete = regRuleParams.isDelete!
        self.priority = regRuleParams.priority!
    }
}
