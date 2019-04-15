//
//  ParserManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/26.
//

class ParserManager {
    private let defaultDataManager: ParserDefaultDataManager
    private let repository: Repository
    private let ruleManager: RegRuleManager
    private let senderCandidateManager: SenderCandidateManager

    init(repository: Repository, secretKey: String) throws {
        self.defaultDataManager = try ParserDefaultDataManager(repository: repository, secretKey: secretKey)
        self.repository = repository
        self.senderCandidateManager = SenderCandidateManager(repository: repository)
        self.ruleManager = try RegRuleManager(repository:repository)

        try setDefaultData()
    }

    private enum ParserManagerError: Error {
        case canNotSaveDefaultParserData
        case canNotSaveParserData
    }

    private func setDefaultData() throws {
        do {
            guard let parserData = try defaultDataManager.getData() else {
                return
            }

            try saveData(parserData)
        } catch {
            throw ParserManagerError.canNotSaveDefaultParserData
        }
    }

    private func createParsingData(by fullSmsData: FullSmsData,
                                   _ senderCandidates: [String]) throws -> ParsingData? {
        for sender in senderCandidates {
            let regRules = try self.ruleManager.findRegRules(by: sender)
            for regRule in regRules {
                let smsRegMatcher = SmsRegMatcher(contents: fullSmsData.replaced, regExp: regRule.regExpression)
                guard let result = smsRegMatcher.match() else {
                    continue
                }

                try self.ruleManager.saveMatchedRegRule(sender: sender, matchedRegRule: regRule)

                let processor = ParsingProcessor(fullSmsData: fullSmsData,
                                                 regRule: regRule,
                                                 regMatchResult: result)
                return processor.parsingData()
            }
        }

        return nil
    }

    func parse(all fullSmses: [FullSms], completion: @escaping (Error?, [ParsingData]) -> Void) {
        do {
            var parsingDatas: [ParsingData] = []
            let fullSmsDatas = fullSmses.map({ FullSmsData(ori: $0) })
            let senderCandidate = try self.senderCandidateManager.createSenderCandidate()
            for fullSmsData in fullSmsDatas {
                let candidate = senderCandidate.findCandidateLists(by: fullSmsData)
                if let parsingData = try self.createParsingData(by: fullSmsData,
                                                                candidate.potentialLists) {
                    parsingDatas.append(parsingData)
                    continue
                }

                if let parsingData = try self.createParsingData(by: fullSmsData,
                                                                candidate.restLists) {
                    parsingDatas.append(parsingData)
                    continue
                }
            }

            return completion(nil, parsingDatas)
        } catch {
            return completion(error, [])
        }
    }

    func getVersion() throws -> Int {
        guard let regRuleVersion = try repository.regRuleVersion.findCurrentVersion() else {
            return DefaultRegVersion.version.rawValue
        }

        return regRuleVersion.version
    }

    func saveData(_ parserData: ParserData) throws {
        try repository.dbManager.beginTransaction()

        do {
            repository.regRuleVersion.save(parserData.regRuleVersion)

            if !parserData.regRules.isEmpty {
                repository.regRule.save(all: parserData.regRules)
            }

            if !parserData.senders.isEmpty {
                repository.sender.save(all: parserData.senders)
            }

            if !parserData.repSenderNames.isEmpty {
                repository.repSenderName.save(all: parserData.repSenderNames)
            }

            try repository.dbManager.commit()
        } catch {
            repository.dbManager.rollback()
            throw ParserManagerError.canNotSaveParserData
        }
    }
}
