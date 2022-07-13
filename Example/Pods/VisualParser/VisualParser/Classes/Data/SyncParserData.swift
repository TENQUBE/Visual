//
//  SyncData.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/25.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct SyncParserData {
    let regRules: [RegRuleData]?
    let senders: [SenderData]?
    let regRuleVersion: Int?
    let repSenderNames: [RepSenderNameData]?

    public init(regRules: [RegRuleData]?,
         senders: [SenderData]?,
         regRuleVersion: Int?,
         repSenderNames: [RepSenderNameData]?) {
        self.regRules = regRules ?? []
        self.senders = senders ?? []
        self.regRuleVersion = regRuleVersion
        self.repSenderNames = repSenderNames
    }

    func isNotEmpty() -> Bool {
        return regRules != nil || senders != nil || regRuleVersion != nil || repSenderNames != nil
    }
}
