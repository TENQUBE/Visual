//
//  RegRuleVersionRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

protocol RegRuleVersionRepository {
    func findCurrentVersion() throws -> RegRuleVersionData?
    func save(_ regRuleVersion: Int, _ updateAt: Date)
}

extension RegRuleVersionRepository {
    func save(_ regRuleVersion: Int, _ updateAt: Date = Date()) {
        save(regRuleVersion, updateAt)
    }
}
