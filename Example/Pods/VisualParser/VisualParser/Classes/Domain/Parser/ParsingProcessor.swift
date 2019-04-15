//
//  RefactParser.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/20.
//

struct ParsingProcessor: ParsingDataProcessor {
    let fullSmsData: FullSmsData
    let regRule: RegRuleData
    let extractor: SmsExtractor

    init(fullSmsData: FullSmsData, regRule: RegRuleData, regMatchResult: NSTextCheckingResult) {
        self.fullSmsData = fullSmsData
        self.regRule = regRule
        self.extractor = SmsExtractor(str: fullSmsData.replaced, regMatchResult: regMatchResult)
    }

    private func parseCardName() -> String {
        let extractCardName = extractor.extract(position: regRule.cardName)
        let cardName = transformCardName(with: extractCardName)

        return cardName
    }

    private func parseCardNum() -> String {
        let extractCardNum = extractor.extract(position: regRule.cardNum)
        let cardNum = transformCardNum(with: extractCardNum)

        return cardNum
    }

    private func parseCardType() -> Int {
        let extractCardType = extractor.extract(position: regRule.cardType)
        let cardType = transformCardType(with: extractCardType)

        return cardType
    }

    private func parseCardSubType() -> Int {
        let extractCardSubType = extractor.extract(position: regRule.cardSubType)
        let cardSubType = transformCardSubType(with: extractCardSubType)

        return cardSubType
    }

    private func parseCardBalance() -> Double {
        let extractCardBalance = extractor.extract(position: regRule.balance)
        let cardBalance = transformCardBalance(with: extractCardBalance)

        return cardBalance
    }

    private func parseSpentMoney() -> Double {
        var extractSpentMoney = extractor.extract(position: regRule.spentMoney)

        var isUnitManWon = false
        if extractSpentMoney.contains(Word.manwon.rawValue) {
            isUnitManWon = true
            let spentMoneyRegMatcher = SpentMoneyRegMatcher(contents: extractSpentMoney)
            let spentMoneyRegMatchResult = spentMoneyRegMatcher.match()
            if spentMoneyRegMatchResult != nil {
                let spentMoneyExtractor = SpentMoneyExtractor(str: extractSpentMoney,
                                                              regMatchResult: spentMoneyRegMatchResult!)
                extractSpentMoney = spentMoneyExtractor.extract()
            }
        }

        return transformSpentMoney(with: extractSpentMoney, isUnitManWon: isUnitManWon)
    }

    private func parseSpentDate() -> String {
        if regRule.spentDate.isEmpty {
            return fullSmsData.createAt
        }

        var extractSpentDate = extractor.extract(position: regRule.spentDate)
        if extractSpentDate.isEmpty {
            return fullSmsData.createAt
        }

        let spentDateRegMatcher = SpentDateRegMatcher(contents: extractSpentDate)
        let (spentDateRegMatchResult, regMatchId) = spentDateRegMatcher.match()
        if spentDateRegMatchResult != nil {
            let spentDateExtractor = SpentDateExtractor(str: extractSpentDate,
                                                        regMatchResult: spentDateRegMatchResult!,
                                                        smsDate: fullSmsData.createAt)
            extractSpentDate = spentDateExtractor.extract(regMatchId: regMatchId)
        }

        var spentDate = transformSpentDate(with: extractSpentDate, or: fullSmsData.createAt)
        if spentDate.isOver(than: fullSmsData.createAt) {
            spentDate = spentDate.add(year: -1)
        }

        return spentDate
    }

    private func parseInstallmentCount() -> Int {
        let extractInstallmentCount = extractor.extract(position: regRule.installmentCount)
        let installmentCount = transformInstallmentCount(with: extractInstallmentCount)

        return installmentCount
    }

    private func parseKeyword() -> String {
        let extractKeyword = extractor.extract(position: regRule.keyword)
        if extractKeyword.isEmpty {
            return Keyword.empty.rawValue
        }

        let keyword = transformKeyword(with: extractKeyword)
        if keyword.isEmpty {
            return Keyword.empty.rawValue
        }

        var shouldMatchReg = false
        for candidate in Word.keywordRegMatchCandidate.list {
            if keyword.contains(candidate) {
                shouldMatchReg = true
                break
            }
        }
        if !shouldMatchReg {
            return keyword
        }

        var regMatchKeyword: String = Keyword.empty.rawValue
        let keywordRegMatcher = KeywordRegMatcher(contents: keyword)
        let keywordRegMatchResult = keywordRegMatcher.match()
        if keywordRegMatchResult != nil {
            let keywordExtractor = KeywordExtractor(str: keyword, regMatchResult: keywordRegMatchResult!)
            regMatchKeyword = keywordExtractor.extract()
        }

        return regMatchKeyword.isEmpty ? Keyword.empty.rawValue : regMatchKeyword
    }

    private func parseDwType() -> Int {
        let extractDwType = extractor.extract(position: regRule.dwType)

        return transformDwType(with: extractDwType)
    }

    private func parseCurrency() -> String {
        let extractCurrency = extractor.extract(position: regRule.currency)

        return transformCurrency(with: extractCurrency)
    }

    private func parseUserName() -> String {
        let extractUserName = extractor.extract(position: regRule.userName)

        return transformUserName(with: extractUserName)
    }

    private func parseIsCancel() -> Bool {
        let extractIsCancel = extractor.extract(position: regRule.isCancel)

        return transformIsCancel(with: extractIsCancel)
    }

    func parsingData() -> ParsingData {
        let parsingCard = CardData((name: parseCardName(),
                                    num: parseCardNum(),
                                    type: parseCardType(),
                                    subType: parseCardSubType(),
                                    balance: parseCardBalance()))
        let parsingTransaction = TransactionExtData((regRuleId: regRule.regId,
                                                     spentMoney: parseSpentMoney(),
                                                     spentDate: parseSpentDate(),
                                                     installmentCount: parseInstallmentCount(),
                                                     keyword: parseKeyword(),
                                                     dwType: parseDwType(),
                                                     currency: parseCurrency(),
                                                     userName: parseUserName(),
                                                     isCancel: parseIsCancel()))
        return ParsingData(fullSmsData, parsingCard, parsingTransaction)
    }
}
