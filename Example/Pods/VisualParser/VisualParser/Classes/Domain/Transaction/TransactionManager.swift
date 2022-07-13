//
//  TransactionManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

class TransactionManager {
    private let repository: Repository
    private let parserAPIService: ParserAPI

    init(repository: Repository, parserAPI: ParserAPI) {
        self.repository = repository
        self.parserAPIService = parserAPI
    }

    private func createCurrencyRateDict(by currencies: [String],
                                        completion: @escaping ([String: Double]) -> Void) {
        var currencyRateDict = [String: Double]()
        if currencies.isEmpty {
            return completion(currencyRateDict)
        }

        let currencyReqDatas = currencies.map({ CurrencyRequestData(from: $0 )})
        parserAPIService.getCurrency(reqData: currencyReqDatas) { resDatas in

            for resData in resDatas {
                currencyRateDict[resData.from] = resData.rate
            }

            return completion(currencyRateDict)
        }
    }

    private func createParsedTransacion(by parsingResults: [ParsingData],
                                        completion: @escaping (Error?, [TransactionData]) -> Void) {
        let currencies = parsingResults
            .filter({ parsingResult -> Bool in
                let isEmpty = parsingResult.transaction.currency.isEmpty
                let isKRW = parsingResult.transaction.currency == "KRW"
                return !isEmpty && !isKRW
            })
            .map({ $0.transaction.currency })

        createCurrencyRateDict(by: currencies) { currencyDict in
            do {
                let transactions = try parsingResults.map({ parsingResult -> TransactionData in
                    var spentMoney = parsingResult.transaction.spentMoney
                    if let rate = currencyDict[parsingResult.transaction.currency] {
                        spentMoney = spentMoney * rate
                    }

                    if parsingResult.transaction.isCancel {
                        if let categoryCode = try self.findOriCancelTranCategoryCode(by: parsingResult) {
                            return TransactionData(parsingResult, spentMoney, categoryCode)
                        }
                    } else if try self.doMoneyTransferToSelf(by: parsingResult) {
                        return TransactionData(parsingResult, spentMoney, isMovedAsset: true)
                    }

                    return TransactionData(parsingResult, spentMoney)
                })

                return completion(nil, transactions)
            } catch {
                return completion(error, []);
            }
        }
    }

    private func doMoneyTransferToSelf(by parsingResult: ParsingData) throws -> Bool {
        let card = parsingResult.card

        guard let spentDate = parsingResult.transaction.spentDate.toDate(),
            let fromDate = spentDate.add(min: -3),
            let toDate = spentDate.add(min: 3)
            else { return false }

        if let _ = try repository.transactionManager.findMovedAssets(usedCardId: card.id,
                                                                     usedCardType: card.type,
                                                                     from: fromDate,
                                                                     to: toDate,
                                                                     dwType: parsingResult.transaction.dwType,
                                                                     money: parsingResult.transaction.spentMoney) {
            return true
        } else {
            return false
        }
    }

    private func findOriCancelTranCategoryCode(by parsingResult: ParsingData) throws -> Int? {
        let card = parsingResult.card

        guard let twoMonthAgoDate = parsingResult.transaction.spentDate.toDate()?.add(month: -2) else { return nil }
        let firstDateOfTwoMonthAgo = "\(twoMonthAgoDate.year)-\(twoMonthAgoDate.month)-01 00:00:00"

        guard let fromDate = firstDateOfTwoMonthAgo.toDate() else { return nil }
        guard let toDate = parsingResult.transaction.spentDate.toDate() else { return nil }

        let results = try repository.transactionManager.findAllNotCanceled(usedCardId: card.id,
                                                                           from: fromDate,
                                                                           to: toDate,
                                                                           money: parsingResult.transaction.spentMoney,
                                                                           dwType: parsingResult.transaction.dwType)

        guard let result = results
            .filter({
                $0.keyword.contains(parsingResult.transaction.keyword) ||
                    parsingResult.transaction.keyword.contains($0.keyword)
            })
            .first
            else { return nil }

        return result.categoryCode
    }

    private func searchCompany(by transactions: [TransactionData],
                               completion: @escaping ([String: SearchCompanyResponseData]) -> Void) {
        let reqDatas = transactions.map({ SearchCompanyRequestData($0) })
        parserAPIService.searchCompany(reqData: reqDatas) { (err, resDatas) in
            var comResDataDict = [String: SearchCompanyResponseData]()

            if err != nil {
                return completion(comResDataDict)
            }

            guard let companyResDatas = resDatas else {
                return completion(comResDataDict)
            }

            for companyResData in companyResDatas {
                comResDataDict[companyResData.id] = companyResData
            }

            return completion(comResDataDict)
        }
    }

    func createTransactions(by parsingResults: [ParsingData],
                            completion: @escaping (Error?, [TransactionData]) -> Void) {
        createParsedTransacion(by: parsingResults) { (err, parsedTransactions) in
            if err != nil {
                return completion(err, []);
            }

            self.searchCompany(by: parsedTransactions) { resDataDict in
                let transactions = parsedTransactions.map({ parsedTransaction -> TransactionData in
                    guard let companyResData = resDataDict[parsedTransaction.identifier] else {
                        return parsedTransaction
                    }

                    return TransactionData(parsedTransaction, companyResData)
                })

                return completion(nil, transactions)
            }
        }
    }

    func saveTransactions(_ transactions: [TransactionData]) throws {
        let tranManagerData = transactions
            .map({ TransactionManagerData((identifier: $0.identifier,
                                           cardId: $0.cardId,
                                           cardType: $0.cardType,
                                           spentMoney: $0.spentMoney,
                                           spentDate: $0.spentDate,
                                           installmentCount: $0.installmentCount,
                                           keyword: $0.keyword,
                                           dwType: $0.dwType,
                                           isCancel: $0.isOffSet,
                                           categoryCode: $0.categoryCode)) })

        try repository.dbManager.beginTransaction()
        do {
            repository.transactionManager.saveAll(tranManagerData)
            try repository.dbManager.commit()
        } catch {
            repository.dbManager.rollback()
            throw error
        }
    }
}
