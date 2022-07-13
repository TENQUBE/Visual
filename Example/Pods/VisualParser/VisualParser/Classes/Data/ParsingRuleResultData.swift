//
//  ParsingRuleResult.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

struct ParsingRuleResultData {
    let sender: String
    let regRuleId: Int

    init(_ sender: String, _ regRuleId: Int) {
        self.sender = sender
        self.regRuleId = regRuleId
    }
}
