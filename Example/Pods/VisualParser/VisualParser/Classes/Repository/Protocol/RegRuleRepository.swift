//
//  RegRuleRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

protocol RegRuleRepository {
    func findAll() throws -> [RegRuleData]
    func findAllNotDeleted(by repSender: String) throws -> [RegRuleData]
    func findNotDeleted(by regId: Int) throws -> RegRuleData?
    func save(all regRules: [RegRuleData])
}
