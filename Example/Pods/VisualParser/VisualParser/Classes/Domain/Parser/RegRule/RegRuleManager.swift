//
//  RuleManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/15.
//

class RegRuleManager {
    let repository: Repository
    private var matchedSenderRegRule = SenderRegRuleDict()
    private var localCacheSenderRegRuleDict = SenderRegRuleDict()
    private var localCacheSenderRegRulesDict = SenderRegRulesDict()

    init(repository: Repository) throws {
        self.repository = repository
        try self.setMatchedSenderRegRule()
    }

    private func setMatchedSenderRegRule() throws {
        let parsingRuleResults = try repository.parsingResult.findAll()
        if parsingRuleResults.isEmpty {
            return
        }

        for parsingRuleResult in parsingRuleResults {
            guard let regRule = try repository.regRule.findNotDeleted(by: parsingRuleResult.regRuleId)
            else { continue }

            matchedSenderRegRule[regRule.repSender] = regRule
        }
    }

    private func saveMatchedSenderRegRuleId(_ sender: String, _ regId: Int) throws {
        try repository.dbManager.beginTransaction()

        do {
            repository.parsingResult.save(key: sender, value: regId)
            try repository.dbManager.commit()
        } catch {
            repository.dbManager.rollback()
            throw error
        }
    }

    func findRegRules(by sender: String) throws -> [RegRuleData] {
        if let regRules = localCacheSenderRegRulesDict[sender] {
            return regRules
        }

        var results: [RegRuleData] = []
        let regRules = try repository.regRule.findAllNotDeleted(by: sender)
        if !regRules.isEmpty {
            let matchedRegRule = matchedSenderRegRule[sender]
            let localCacheRegRule = localCacheSenderRegRuleDict[sender]

            if matchedRegRule == nil && localCacheRegRule == nil {
                results = regRules
            } else {
                var sorter: RegRuleSorter
                if matchedRegRule != nil && localCacheRegRule == nil {
                    sorter = RegRuleSorter(regRules, matchedRegRule!)
                } else if matchedRegRule == nil && localCacheRegRule != nil {
                    sorter = RegRuleSorter(regRules, localCacheRegRule!)
                } else {
                    sorter = RegRuleSorter(regRules, matchedRegRule!, localCacheRegRule!)
                }

                results = sorter.regRules
            }
        }

        localCacheSenderRegRulesDict[sender] = results
        return results
    }

    func saveMatchedRegRule(sender: String, matchedRegRule: RegRuleData) throws {
        let localCacheRegRule = localCacheSenderRegRuleDict[sender]

        if let matchedRegRule = matchedSenderRegRule[sender] {
            let isDiffMatcheRegId = matchedRegRule.regId != matchedRegRule.regId

            if localCacheRegRule == nil {
                if isDiffMatcheRegId {
                    localCacheSenderRegRuleDict[sender] = matchedRegRule
                }
            } else {
                let isDiffLocalCacheRegId = localCacheRegRule!.regId != matchedRegRule.regId
                if isDiffMatcheRegId && isDiffLocalCacheRegId {
                    localCacheSenderRegRuleDict[sender] = matchedRegRule
                }
            }
        } else {
            if localCacheRegRule == nil {
                localCacheSenderRegRuleDict[sender] = matchedRegRule
            } else {
                let isDiffLocalCacheRegId = localCacheRegRule!.regId != matchedRegRule.regId
                if isDiffLocalCacheRegId {
                    localCacheSenderRegRuleDict[sender] = matchedRegRule
                }
            }
        }

        try saveMatchedSenderRegRuleId(sender, matchedRegRule.regId)
    }
}


