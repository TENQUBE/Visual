//
//  RegRuleVersionRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

class RegRuleVersionRealmRepository: RealmRepository, RegRuleVersionRepository {
    func findCurrentVersion() throws -> RegRuleVersionData? {
        guard let obj = try realmManager.getObjects(table: ParserRegRuleVersionModel.self).first,
            let regRuleVersionModel = obj as? ParserRegRuleVersionModel else {
                return nil
        }

        return RegRuleVersionData(regRuleVersionModel.version,
                                  regRuleVersionModel.updateAt as Date)
    }

    func save(_ newRegRuleVersion: Int, _ updateAt: Date = Date()) {
        let regRuleVersionModel = ParserRegRuleVersionModel()
        regRuleVersionModel.id = DefaultRegVersion.id.rawValue
        regRuleVersionModel.version = newRegRuleVersion
        regRuleVersionModel.updateAt = updateAt as NSDate

        realmManager.saveObject(obj: regRuleVersionModel, onDuplicateKeyUpdate: true)
    }
}
