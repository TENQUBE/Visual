//
//  ParserData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/26.
//

public struct ParserData {
    public let regRuleVersion: Int
    public let regRules: [RegRuleData]
    public let senders: [SenderData]
    public let repSenderNames: [RepSenderNameData]

    public init(regRuleVersion: Int, regRules: [RegRuleData],
         senders: [SenderData], repSenderNames: [RepSenderNameData]) {
        self.regRuleVersion = regRuleVersion
        self.regRules = regRules
        self.senders = senders
        self.repSenderNames = repSenderNames
    }
}
