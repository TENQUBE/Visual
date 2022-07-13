//
//  Validation.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

class Validation {
    static let shared = Validation()

    private let validatorDict: [String: ValidationRule]

    enum ParameterError: Error {
        case invalidValue(type: String, name: String)
    }

    init() {
        validatorDict = [
            "smsId": SmsIdRule(),
            "fullSms": FullSmsRule(),
            "displayName": DisplayNameRule(),
            "sender": SenderRule(),
            "smsDate": SmsDateRule(),
            "smsType": SmsTypeRule(),
            "title": TitleRule(),
            "regId": RegIdRule(),
            "repSender": RepSenderRule(),
            "regExpression": RegExpressionRule(),
            "cardName": CardNameRule(),
            "cardType": CardTypeRule(),
            "cardSubType": CardSubTypeRule(),
            "cardNum": CardNumRule(),
            "spentMoney": SpentMoneyRule(),
            "spentDate": SpentDateRule(),
            "keyword": KeywordRule(),
            "installmentCount": InstallmentCountRule(),
            "dwType": DwTypeRule(),
            "isCancel": IsCancelRule(),
            "currency": CurrencyRule(),
            "balance": BalanceRule(),
            "userName": UserNameRule(),
            "isDelete": IsDeleteRule(),
            "priority": PriorityRule(),
            "senderId": SenderIdRule(),
            "repSenderId": RepSenderIdRule()
        ]
    }

    private func validate(from dict: [String: String?], type: String) throws {
        for (key, value) in dict {
            if let isValid = validatorDict[key]?.isValid(value), !isValid {
                throw ParameterError.invalidValue(type: type, name: key)
            }
        }
    }

    private func validate(from dict: [String: Int?], type: String) throws {
        for (key, value) in dict {
            if let isValid = validatorDict[key]?.isValid(value), !isValid {
                throw ParameterError.invalidValue(type: type, name: key)
            }
        }
    }

    func validate(_ senderParams: SenderParams, _ type: String = "Sender") throws {
        let strValueDict: [String: String?] = [
            "sender": senderParams.sender,
            "repSender": senderParams.repSender
        ]

        let intValueDict: [String: Int?] = [
            "senderId": senderParams.senderId,
            "smsType": senderParams.smsType,
            "isDelete": senderParams.isDelete
        ]

        try validate(from: strValueDict, type: type)
        try validate(from: intValueDict, type: type)
    }

    func validate(_ regRuleParams: RegRuleParams, _ type: String = "RegRule") throws {
        let strValueDict: [String: String?] = [
            "repSender": regRuleParams.repSender,
            "regExpression": regRuleParams.regExpression,
            "cardName": regRuleParams.cardName,
            "cardType": regRuleParams.cardType,
            "cardSubType": regRuleParams.cardSubType,
            "cardNum": regRuleParams.cardNum,
            "spentMoney": regRuleParams.spentMoney,
            "spentDate": regRuleParams.spentDate,
            "keyword": regRuleParams.keyword,
            "installmentCount": regRuleParams.installmentCount,
            "dwType": regRuleParams.dwType,
            "isCancel": regRuleParams.isCancel,
            "currency": regRuleParams.currency,
            "balance": regRuleParams.balance,
            "userName": regRuleParams.userName
        ]

        let intValueDict: [String: Int?] = [
            "regId": regRuleParams.regId,
            "smsType": regRuleParams.smsType,
            "isDelete": regRuleParams.isDelete,
            "priority": regRuleParams.priority
        ]

        try validate(from: strValueDict, type: type)
        try validate(from: intValueDict, type: type)
    }

    func validate(_ params: RepSenderNameParams, _ type: String = "RepSenderName") throws {
        let strValueDict: [String: String?] = [
            "sender": params.sender,
            "repSender": params.repSender
        ]

        let intValueDict: [String: Int?] = [
            "repSenderId": params.id,
            "isDelete": params.isDelete
        ]

        try validate(from: strValueDict, type: type)
        try validate(from: intValueDict, type: type)
    }
}
