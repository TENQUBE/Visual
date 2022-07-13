//
//  ParsingResultRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

class ParsingResultRealmRepository: RealmRepository, ParsingResultRepository {
    func save(key: String, value: Int) {
        let parsingResultModel = ParserParsingResultModel()
        parsingResultModel.regRuleId = value
        parsingResultModel.sender = key

        realmManager.saveObject(obj: parsingResultModel, onDuplicateKeyUpdate: true)
    }

    func find(key sender: String) throws -> ParsingRuleResultData? {
        let whereCond = NSPredicate(format: "sender = %@", sender)
        guard let obj = try realmManager.getObjects(table: ParserParsingResultModel.self, cond: whereCond).first,
            let parsingResultModel = obj as? ParserParsingResultModel else {
                return nil
        }

        return ParsingRuleResultData(parsingResultModel.sender, parsingResultModel.regRuleId)
    }

    func findAll() throws -> [ParsingRuleResultData] {
        var results: [ParsingRuleResultData] = []

        let objects = try realmManager.getObjects(table: ParserParsingResultModel.self)

        for obj in objects {
            if let parsingResultModel = obj as? ParserParsingResultModel {
                results.append(ParsingRuleResultData(parsingResultModel.sender, parsingResultModel.regRuleId))
            }
        }

        return results
    }
}
