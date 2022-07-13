//
//  RepSenderNameRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/28.
//  Copyright © 2019 tenqube. All rights reserved.
//

protocol RepSenderNameRepository {
    func findAll() throws -> [RepSenderNameData]
    func findAllNotDeleted() throws -> [RepSenderNameData]
    func save(all repSenderNameData: [RepSenderNameData])
}
