//
//  ParserResponse.swift
//  Visual
//
//  Created by tenqube on 26/03/2019.
//

import Foundation
class ParserResponse: Codable {
    let regDatas: [RegRule]
    let senders: [Sender]
    let ruleVersion: Int
    let repSenderMaps: [RepSenderMaps]
}

public struct RegRule: Codable {
    let regId: Int
    let regExpression: String
    
    let sender: String
    
    let cardName: String
    let cardNum: String
    let cardType: String
    let cardSubType: String
    let balance: String
    let spentMoney: String
    let spentDate: String
    let keyword: String
    let installmentCount: String
    let dwType: String
    let isCancel: String
    let currency: String
    let userName: String
    let smsType: Int
    let isDelete: Int
    let priority: Int

}

class Sender: Codable {
    let senderId: Int
    let smsType: Int
    let sender: String
    let repSender: String
    let isDelete: Int
}

class RepSenderMaps: Codable {
    let id: Int
    let repSender: String
    let sender: String
    let isDelete: Int
}
