//
//  ParserDataProcessor.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/25.
//  Copyright © 2019 tenqube. All rights reserved.
//

import SwiftyJSON

class ParserRawDataProcessor {
    static func transformSenders(from newRepSenders: JSON) -> [SenderData] {
        var senders: [SenderData] = []

        if let newRepSenders = newRepSenders.array {
            for newRepSender in newRepSenders {
                guard let senderId = newRepSender["senderId"].int,
                    let smsType = newRepSender["smsType"].int,
                    let sender = newRepSender["sender"].string,
                    let repSender = newRepSender["repSender"].string,
                    let isDelete = newRepSender["isDelete"].int
                else { continue }

                guard let senderData = try? SenderData((senderId: senderId,
                                                        smsType: smsType,
                                                        sender: sender,
                                                        repSender: repSender,
                                                        isDelete: isDelete))
                else { continue }

                senders.append(senderData)
            }
        }

        return senders
    }

    static func transformRegRules(from newRegRules: JSON) -> [RegRuleData] {
        var regRules: [RegRuleData] = []

        if let newRegRules = newRegRules.array {
            for newRegRule in newRegRules {
                guard let regId = newRegRule["regId"].int,
                    let repSender = newRegRule["repSender"].string,
                    let regExpression = newRegRule["regExpression"].string,
                    let cardName = newRegRule["cardName"].string,
                    let cardType = newRegRule["cardType"].string,
                    let cardSubType = newRegRule["cardSubType"].string,
                    let cardNum = newRegRule["cardNum"].string,
                    let spentMoney = newRegRule["spentMoney"].string,
                    let spentDate = newRegRule["spentDate"].string,
                    let keyword = newRegRule["keyword"].string,
                    let installmentCount = newRegRule["installmentCount"].string,
                    let dwType = newRegRule["dwType"].string,
                    let isCancel = newRegRule["isCancel"].string,
                    let currency = newRegRule["currency"].string,
                    let balance = newRegRule["balance"].string,
                    let userName = newRegRule["userName"].string,
                    let smsType = newRegRule["smsType"].int,
                    let isDelete = newRegRule["isDelete"].int,
                    let priority = newRegRule["priority"].int
                else {
                    continue
                }

                guard let regRule = try? RegRuleData((regId: regId,
                                                      repSender: repSender,
                                                      regExpression: regExpression,
                                                      cardName: cardName,
                                                      cardType: cardType,
                                                      cardSubType: cardSubType,
                                                      cardNum: cardNum,
                                                      spentMoney: spentMoney,
                                                      spentDate: spentDate,
                                                      keyword: keyword,
                                                      installmentCount: installmentCount,
                                                      dwType: dwType,
                                                      isCancel: isCancel,
                                                      currency: currency,
                                                      balance: balance,
                                                      userName: userName,
                                                      smsType: smsType,
                                                      isDelete: isDelete,
                                                      priority: priority))
                else { continue }

                regRules.append(regRule)
            }
        }

        return regRules
    }

    static func transformRegRuleVersion(from newRegRuleVersion: JSON) -> Int? {
        guard let regRuleVersion = newRegRuleVersion.int else {
            return nil
        }

        return regRuleVersion
    }

    static func transformRegRuleVersionUpdateAt(from newUpdateAt: JSON) -> Date? {
        guard let updateAt = newUpdateAt.string, let result = updateAt.toDate() else {
            return nil
        }

        return result
    }

    static func transformRepSenderNames(from newRepSenderNames: JSON) -> [RepSenderNameData] {
        var repSenderNames: [RepSenderNameData] = []

        if let newRepSenderNames = newRepSenderNames.array {
            for newRepSenderName in newRepSenderNames {
                guard let id = newRepSenderName["id"].int,
                    let repSender = newRepSenderName["repSender"].string,
                    let sender = newRepSenderName["sender"].string,
                    let isDelete = newRepSenderName["isDelete"].int
                else { continue }

                guard let repSenderName = try? RepSenderNameData((id: id,
                                                                  repSender: repSender,
                                                                  sender: sender,
                                                                  isDelete: isDelete))
                else { continue }

                repSenderNames.append(repSenderName)
            }
        }

        return repSenderNames
    }
}
