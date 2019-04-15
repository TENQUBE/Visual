//
//  RegRuleRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

class RegRuleRealmRepository: RealmRepository, RegRuleRepository {
    func findAll() throws -> [RegRuleData] {
        var results: [RegRuleData] = []

        let objects = try realmManager.getObjects(table: ParserRegRuleModel.self)

        for obj in objects {
            if let regRuleModel = obj as? ParserRegRuleModel {
                results.append(try RegRuleData((regId: regRuleModel.regId,
                                                repSender: regRuleModel.repSender,
                                                regExpression: regRuleModel.regExpression,
                                                cardName: regRuleModel.cardName,
                                                cardType: regRuleModel.cardType,
                                                cardSubType: regRuleModel.cardSubType,
                                                cardNum: regRuleModel.cardNum,
                                                spentMoney: regRuleModel.spentMoney,
                                                spentDate: regRuleModel.spentDate,
                                                keyword: regRuleModel.keyword,
                                                installmentCount: regRuleModel.installmentCount,
                                                dwType: regRuleModel.dwType,
                                                isCancel: regRuleModel.isCancel,
                                                currency: regRuleModel.currency,
                                                balance: regRuleModel.balance,
                                                userName: regRuleModel.userName,
                                                smsType: regRuleModel.smsType,
                                                isDelete: regRuleModel.isDelete,
                                                priority: regRuleModel.priority)))
            }
        }

        return results
    }

    func findAllNotDeleted(by repSender: String) throws -> [RegRuleData] {
        var results: [RegRuleData] = []

        let whereCond = NSPredicate(format: "isDelete = 0 AND repSender = %@", repSender)
        let objects = try realmManager.getObjects(table: ParserRegRuleModel.self, cond: whereCond)

        for obj in objects.sorted(byKeyPath: "priority", ascending: false) {
            if let regRuleModel = obj as? ParserRegRuleModel {
                results.append(try RegRuleData((regId: regRuleModel.regId,
                                                repSender: regRuleModel.repSender,
                                                regExpression: regRuleModel.regExpression,
                                                cardName: regRuleModel.cardName,
                                                cardType: regRuleModel.cardType,
                                                cardSubType: regRuleModel.cardSubType,
                                                cardNum: regRuleModel.cardNum,
                                                spentMoney: regRuleModel.spentMoney,
                                                spentDate: regRuleModel.spentDate,
                                                keyword: regRuleModel.keyword,
                                                installmentCount: regRuleModel.installmentCount,
                                                dwType: regRuleModel.dwType,
                                                isCancel: regRuleModel.isCancel,
                                                currency: regRuleModel.currency,
                                                balance: regRuleModel.balance,
                                                userName: regRuleModel.userName,
                                                smsType: regRuleModel.smsType,
                                                isDelete: regRuleModel.isDelete,
                                                priority: regRuleModel.priority)))
            }
        }

        return results
    }

    func findNotDeleted(by regId: Int) throws -> RegRuleData? {
        let whereCond = NSPredicate(format: "regId = \(regId) AND isDelete = 0")
        guard let obj = try realmManager.getObjects(table: ParserRegRuleModel.self, cond: whereCond).first,
            let regRuleModel = obj as? ParserRegRuleModel else {
            return nil
        }

        return try RegRuleData((regId: regRuleModel.regId,
                                repSender: regRuleModel.repSender,
                                regExpression: regRuleModel.regExpression,
                                cardName: regRuleModel.cardName,
                                cardType: regRuleModel.cardType,
                                cardSubType: regRuleModel.cardSubType,
                                cardNum: regRuleModel.cardNum,
                                spentMoney: regRuleModel.spentMoney,
                                spentDate: regRuleModel.spentDate,
                                keyword: regRuleModel.keyword,
                                installmentCount: regRuleModel.installmentCount,
                                dwType: regRuleModel.dwType,
                                isCancel: regRuleModel.isCancel,
                                currency: regRuleModel.currency,
                                balance: regRuleModel.balance,
                                userName: regRuleModel.userName,
                                smsType: regRuleModel.smsType,
                                isDelete: regRuleModel.isDelete,
                                priority: regRuleModel.priority))
    }

    func save(all regRules: [RegRuleData]) {
        for regRule in regRules {
            let regRuleModel = ParserRegRuleModel()
            regRuleModel.regId = regRule.regId
            regRuleModel.repSender = regRule.repSender
            regRuleModel.regExpression = regRule.regExpression
            regRuleModel.cardName = regRule.cardName
            regRuleModel.cardType = regRule.cardType
            regRuleModel.cardSubType = regRule.cardSubType
            regRuleModel.cardNum = regRule.cardNum
            regRuleModel.spentMoney = regRule.spentMoney
            regRuleModel.spentDate = regRule.spentDate
            regRuleModel.keyword = regRule.keyword
            regRuleModel.installmentCount = regRule.installmentCount
            regRuleModel.dwType = regRule.dwType
            regRuleModel.isCancel = regRule.isCancel
            regRuleModel.currency = regRule.currency
            regRuleModel.balance = regRule.balance
            regRuleModel.userName = regRule.userName
            regRuleModel.smsType = regRule.smsType
            regRuleModel.isDelete = regRule.isDelete
            regRuleModel.priority = regRule.priority

            realmManager.saveObject(obj: regRuleModel, onDuplicateKeyUpdate: true)
        }
    }
}
