//
//  ParserService.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

public class ParserService {
    private let cardManager: CardManager
    private let parserManager: ParserManager
    private let transactionManager: TransactionManager

    public init(parserAPI: ParserAPI, secretKey: String) throws {
        let repository = try Repository(RealmManager())
        self.cardManager = CardManager(repository: repository)
        self.parserManager = try ParserManager(repository: repository, secretKey: secretKey)
        self.transactionManager = TransactionManager(repository: repository, parserAPI: parserAPI)
    }

    public func getParserVersion() throws -> Int {
        return try parserManager.getVersion()
    }

    public func saveParserData(parserData: ParserData) throws {
        try parserManager.saveData(parserData)
    }

    public func createTransactions(_ fullSmses: [FullSms],
                                   completion: @escaping (Error?, [TransactionData]) -> Void) {
        self.parserManager.parse(all: fullSmses) { (parseError, parsingDatas) in
            if parseError != nil {
                return completion(parseError, [])
            }

            self.transactionManager.createTransactions(by: parsingDatas) { (tranError, transactions) in
                if tranError != nil {
                    return completion(tranError, [])
                }

                do {
                    let cardDict = try self.cardManager.calBalance(by: transactions)
                    try self.cardManager.saveBalances(cardDict)
                    try self.transactionManager.saveTransactions(transactions)

                    return completion(nil, transactions)
                } catch {
                    return completion(error, [])
                }
            }
        }
    }
}
