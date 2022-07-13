//
//  ParsingDataProcessor.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/20.
//

protocol ParsingDataProcessor {
    func transformCardName(with parsedCardName: String) -> String
    func transformCardNum(with parsedCardNum: String) -> String
    func transformCardType(with parsedCardType: String) -> Int
    func transformCardSubType(with parsedCardSubType: String) -> Int
    func transformCardBalance(with parsedCardBalance: String) -> Double
    func transformSpentMoney(with parsedSpentMoney: String, isUnitManWon: Bool) -> Double
    func transformSpentDate(with parsedSpentDate: String, or smsDate: String) -> String
    func transformInstallmentCount(with parsedInstallmentCount: String) -> Int
    func transformKeyword(with parsedKeyword: String) -> String
    func transformDwType(with parsedDwType: String) -> Int
    func transformCurrency(with parsedCurrency: String) -> String
    func transformUserName(with parsedUserName: String) -> String
    func transformIsCancel(with parsedIsCancel: String) -> Bool
}

extension ParsingDataProcessor {
    func transformCardName(with parsedCardName: String) -> String {
        if parsedCardName.isEmpty || parsedCardName.count > 50 {
            return Keyword.empty.rawValue
        }

        var result: String = parsedCardName
        for replaceChar in ReplaceChar.cardName.list {
            result = result.replacingOccurrences(of: replaceChar, with: "")
        }

        return result.trimmingCharacters(in: .whitespaces)
    }

    func transformCardNum(with parsedCardNum: String) -> String {
        if parsedCardNum.isEmpty {
            return ""
        }

        var result: String = parsedCardNum
        for replaceChar in ReplaceChar.cardNum.list {
            result = result.replacingOccurrences(of: replaceChar, with: "")
        }
        result = result.trimmingCharacters(in: .whitespaces)

        if result.count > 4 {
            let index = result.index(result.startIndex, offsetBy: 4)
            return "(\(result[..<index]))"
        } else {
            return "(\(result))"
        }
    }

    func transformCardType(with parsedCardType: String) -> Int {
        return CardType.convertRawValueFrom(name: parsedCardType)
    }

    func transformCardSubType(with parsedCardSubType: String) -> Int {
        return CardSubType.convertRawValueFrom(name: parsedCardSubType)
    }

    func transformCardBalance(with parsedCardBalance: String) -> Double {
        var cardBalance: Double = 0.0
        if parsedCardBalance.isEmpty {
            return cardBalance
        }

        var result: String = parsedCardBalance
        for replaceChar in ReplaceChar.cardBalance.list {
            result = result.replacingOccurrences(of: replaceChar, with: "")
        }

        if let transformResult = Double(result) {
            cardBalance = transformResult
        }

        return cardBalance
    }

    func transformSpentMoney(with parsedSpentMoney: String, isUnitManWon: Bool) -> Double {
        var spentMoney: Double = 0.0

        if parsedSpentMoney.isEmpty {
            return spentMoney
        }

        var result: String = parsedSpentMoney
        for replaceChar in ReplaceChar.spentMoney.list {
            result = result.replacingOccurrences(of: replaceChar, with: "")
        }
        result = result.replacingOccurrences(of: "O", with: "0")

        if let doubleResult = Double(result) {
            spentMoney = doubleResult
        }

        return isUnitManWon ? spentMoney * 10000 : spentMoney
    }

    func transformSpentDate(with parsedSpentDate: String, or smsDate: String) -> String {
        return parsedSpentDate.isDateFormat ? parsedSpentDate : smsDate
    }

    func transformInstallmentCount(with parsedInstallmentCount: String) -> Int {
        var installmentCount: Int = 1

        if parsedInstallmentCount.isEmpty {
            return installmentCount
        }

        if let transformResult = Int(parsedInstallmentCount) {
            installmentCount = transformResult
        }

        return installmentCount
    }

    func transformKeyword(with parsedKeyword: String) -> String {
        var keyword: String = parsedKeyword
        for replaceChar in ReplaceChar.keyword.list {
            keyword = keyword.replacingOccurrences(of: replaceChar, with: "")
        }

        if keyword.isEmpty {
            return keyword
        }

        if let firstChar = keyword.first, ["("].contains(firstChar) {
            let fromFirst = keyword.index(keyword.startIndex, offsetBy: 1)
            keyword = String(keyword[fromFirst...])
        } else if let lastChar = keyword.last, [")", "(", ".", ","].contains(lastChar) {
            let toLast = keyword.index(keyword.startIndex, offsetBy: keyword.count - 1)
            keyword = String(keyword[..<toLast])
        }

        return keyword.trimmingCharacters(in: .whitespaces)
    }

    func transformDwType(with parsedDwType: String) -> Int {
        return Word.depositCandidate.list.contains(parsedDwType) ? DwType.deposit.rawValue : DwType.withdraw.rawValue
    }

    func transformCurrency(with parsedCurrency: String) -> String {
        let currency = parsedCurrency.trimmingCharacters(in: .whitespaces)

        return currency.isEmpty ? "" : Currency.getCode(by: currency)
    }

    func transformUserName(with parsedUserName: String) -> String {
        return parsedUserName.isEmpty ? Word.defaultParseUserName.rawValue : parsedUserName.trimmingCharacters(in: .whitespaces)
    }

    func transformIsCancel(with parsedIsCancel: String) -> Bool {
        if parsedIsCancel.isEmpty {
            return false
        }

        for candidate in Word.cancelCandidate.list where parsedIsCancel == candidate {
            return true
        }

        return false
    }
}
