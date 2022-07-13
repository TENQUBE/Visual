//
//  ParsingResultRealmRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

protocol ParsingResultRepository {
    func save(key: String, value: Int)
    func find(key: String) throws -> ParsingRuleResultData?
    func findAll() throws -> [ParsingRuleResultData]
}
