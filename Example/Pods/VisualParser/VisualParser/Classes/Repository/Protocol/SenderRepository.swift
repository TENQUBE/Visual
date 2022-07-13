//
//  RepSenderRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

protocol SenderRepository {
    func findAll() throws -> [SenderData]
    func find(by smsType: Int, _ sender: String) throws -> SenderData?
    func save(all senders: [SenderData])
}
