//
//  TransactionData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

public struct TransactionData {
    public let fullSms: String
    public let identifier: String
    public let isDuplicate: Int
    public let cardId: String
    public let cardName: String
    public let cardNum: String
    public let cardType: Int
    public let cardSubType: Int
    public let regRuleId: Int
    public let spentDate: String
    public let installmentCount: Int
    public let keyword: String
    public let dwType: Int
    public let currency: String
    public let isOffSet: Int
    public let spentLatitude: Double
    public let spentLongitude: Double
    public let cardBalance: Double
    public let isSuccess: Int
    public let isCurrentTran: Bool
    public let spentMoney: Double
    public let oriSpentMoney: Double

    public var categoryCode: Int
    public var memo: String
    public var finishDate: String

    public var companyId: Int
    public var companyName: String
    public var companyAddress: String
    public var classCode: String
    public var isPopUpCompanyName: Bool

    init(_ parsingResult: ParsingData, _ money: Double) {
        identifier = UUID().uuidString
        isDuplicate = 0
        categoryCode = CategoryCode.notFound.rawValue
        memo = ""
        isSuccess = 1
        isCurrentTran = true

        fullSms = parsingResult.fullSms.replaced
        cardId = parsingResult.card.id
        cardName = parsingResult.card.name
        cardNum = parsingResult.card.num
        cardType = parsingResult.card.type
        cardSubType = parsingResult.card.subType
        cardBalance = parsingResult.card.balance
        regRuleId = parsingResult.transaction.regRuleId
        spentMoney = parsingResult.transaction.isCancel ? money * -1 : money
        oriSpentMoney = parsingResult.transaction.isCancel
            ? parsingResult.transaction.spentMoney * -1
            : parsingResult.transaction.spentMoney
        spentDate = parsingResult.transaction.spentDate
        installmentCount = parsingResult.transaction.installmentCount
        finishDate = spentDate
        keyword = parsingResult.transaction.keyword
        dwType = parsingResult.transaction.dwType
        currency = parsingResult.transaction.currency
        isOffSet = parsingResult.transaction.isCancel ? 1 : 0

        if dwType == 0 {
            companyId = 3998351
            classCode = "DP"
            categoryCode = 901010
        } else {
            if cardType == 2 {
                companyId = 3983436
                classCode = "WFDW"
                categoryCode = 841010
            } else {
                companyId = 1260117
                classCode = "NF"
                categoryCode = 101010
            }
        }
        companyName = "none"
        companyAddress = "none"
        isPopUpCompanyName = false

        let geo = GeoLocationData()
        spentLatitude = geo.lat
        spentLongitude = geo.long

        calFinishDate()
        createMemo()
    }

    init(_ parsingResult: ParsingData, _ spentMoney: Double, isMovedAsset: Bool) {
        self.init(parsingResult, spentMoney)
        if isMovedAsset {
            if dwType == DwTypes.deposit.rawValue {
                categoryCode = CategoryCode.assetsIn.rawValue
            } else {
                categoryCode = CategoryCode.assetsOut.rawValue
            }
        }
    }

    init(_ parsingResult: ParsingData, _ spentMoney: Double, _ categoryCode: Int) {
        self.init(parsingResult, spentMoney)
        self.categoryCode = categoryCode
    }

    init(_ tran: TransactionData, _ company: SearchCompanyResponseData) {
        fullSms = tran.fullSms
        identifier = tran.identifier
        isDuplicate = tran.isDuplicate
        cardId = tran.cardId
        cardName = tran.cardName
        cardNum = tran.cardNum
        cardType = tran.cardType
        cardSubType = tran.cardSubType
        regRuleId = tran.regRuleId
        spentMoney = tran.spentMoney
        oriSpentMoney = tran.oriSpentMoney
        spentDate = tran.spentDate
        installmentCount = tran.installmentCount
        keyword = tran.keyword
        dwType = tran.dwType
        currency = tran.currency
        isOffSet = tran.isOffSet
        spentLatitude = tran.spentLatitude
        spentLongitude = tran.spentLongitude
        cardBalance = tran.cardBalance
        isSuccess = tran.isSuccess
        isCurrentTran = tran.isCurrentTran
        memo = tran.memo
        finishDate = tran.finishDate

        categoryCode = company.categoryCode
        companyId = company.companyId
        companyName = company.companyName
        companyAddress = company.companyAddress
        classCode = company.classCode
        isPopUpCompanyName = company.isPopUpCompanyName
    }

    init(_ tran: TransactionData, _ card: CardData) {
        fullSms = tran.fullSms
        identifier = tran.identifier
        isDuplicate = tran.isDuplicate
        cardId = card.id
        cardName = card.name
        cardNum = card.num
        cardType = card.type
        cardSubType = card.subType
        regRuleId = tran.regRuleId
        spentMoney = tran.spentMoney
        oriSpentMoney = tran.oriSpentMoney
        spentDate = tran.spentDate
        installmentCount = tran.installmentCount
        keyword = tran.keyword
        dwType = tran.dwType
        currency = tran.currency
        isOffSet = tran.isOffSet
        spentLatitude = tran.spentLatitude
        spentLongitude = tran.spentLongitude
        cardBalance = tran.cardBalance
        isSuccess = tran.isSuccess
        isCurrentTran = tran.isCurrentTran
        memo = tran.memo
        finishDate = tran.finishDate

        categoryCode = tran.categoryCode
        companyId = tran.companyId
        companyName = tran.companyName
        companyAddress = tran.companyAddress
        classCode = tran.classCode
        isPopUpCompanyName = tran.isPopUpCompanyName
    }

    mutating private func calFinishDate() {
        if installmentCount == 1 {
            return
        }

        guard let installmentStartDate = spentDate.toDate() else {
            return
        }

        guard let installmentFinishDate = installmentStartDate.add(month: installmentCount) else {
            return
        }

        finishDate = installmentFinishDate.toString()
    }

    mutating private func createMemo() {
        if currency.isEmpty {
            return
        }

        memo = "\(currency) \(spentMoney)"
    }
}
