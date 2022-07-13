//
//  RuleSorter.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/15.
//

struct RegRuleSorter {
    let regRules: [RegRuleData]

    init(_ regRules: [RegRuleData], _ chosenRegRule: RegRuleData) {
        let midRegRule = [chosenRegRule]
        let higherPriorityRegRules = regRules.filter({ regRule in
            let isHigher = regRule.priority > chosenRegRule.priority
            return isHigher })
        let lowerPriorityRegRules = regRules.filter({ regRule in
            let isLower = regRule.priority <= chosenRegRule.priority
            let isNotSame = regRule.regId != chosenRegRule.regId
            return isLower && isNotSame
        })

        self.regRules = higherPriorityRegRules + midRegRule + lowerPriorityRegRules
    }

    init(_ regRules: [RegRuleData], _ matchedRegRule: RegRuleData, _ localCacheRegRule: RegRuleData) {
        let isMatchedRegRuleHigher = matchedRegRule.priority >= localCacheRegRule.priority
        let midFirstRegRule = isMatchedRegRuleHigher ? matchedRegRule : localCacheRegRule
        let midLastRegRule = isMatchedRegRuleHigher ? localCacheRegRule : matchedRegRule
        let highPriority = isMatchedRegRuleHigher ? matchedRegRule.priority : localCacheRegRule.priority
        let lowerPriority = isMatchedRegRuleHigher ? localCacheRegRule.priority : matchedRegRule.priority

        let higherPriorityRegRules = regRules.filter({ $0.priority > highPriority })
        let midPriorityRegRules = regRules.filter({ regRule in
            let isLower = regRule.priority <= highPriority
            let isHigher = regRule.priority > lowerPriority
            let isNotSame = regRule.regId != matchedRegRule.regId && regRule.regId != localCacheRegRule.regId

            return isHigher && isLower && isNotSame
        })
        let lowerPriorityRegRules = regRules.filter({ regRule in
            let isNotSame = regRule.regId != matchedRegRule.regId && regRule.regId != localCacheRegRule.regId
            let isLower = regRule.priority <= lowerPriority

            return isLower && isNotSame
        })

        var results: [RegRuleData]
        if midFirstRegRule.priority == midLastRegRule.priority {
            results = higherPriorityRegRules + [midFirstRegRule] + [midLastRegRule] + midPriorityRegRules + lowerPriorityRegRules
        } else {
            results = higherPriorityRegRules + [midFirstRegRule] + midPriorityRegRules + [midLastRegRule] + lowerPriorityRegRules
        }

        self.regRules = results
    }
}
