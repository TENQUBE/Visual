//
//  Repository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

class Repository {
    let dbManager: DbManager
    let regRule: RegRuleRepository
    let regRuleVersion: RegRuleVersionRepository
    let sender: SenderRepository
    let repSenderName: RepSenderNameRepository
    let parsingResult: ParsingResultRepository
    let card: CardRealmRepository
    let transactionManager: TransactionManagerRealmRepository

    enum RepositoryError: Error {
        case canNotInitRepository
    }

    init(_ dbManager: DbManager, _ secretKey: String) throws {
        guard let realmManager = dbManager as? RealmManager else {
            throw RepositoryError.canNotInitRepository
        }

        self.dbManager = realmManager
        self.regRule = RegRuleRealmRepository(manager: realmManager, secretKey)
        self.regRuleVersion = RegRuleVersionRealmRepository(manager: realmManager)
        self.sender = SenderRealmRepository(manager: realmManager)
        self.repSenderName = RepSenderNameRealmRepository(manager: realmManager)
        self.parsingResult = ParsingResultRealmRepository(manager: realmManager)
        self.card = CardRealmRepository(manager: realmManager)
        self.transactionManager = TransactionManagerRealmRepository(manager: realmManager)
    }
}
