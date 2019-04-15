//
//  RepSenderNameRealmRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/28.
//  Copyright © 2019 tenqube. All rights reserved.
//

class RepSenderNameRealmRepository: RealmRepository, RepSenderNameRepository {
    func findAll() throws -> [RepSenderNameData] {
        var results: [RepSenderNameData] = []

        let objects = try realmManager.getObjects(table: ParserRepSenderNameModel.self)

        for obj in objects {
            if let repSenderNameModel = obj as? ParserRepSenderNameModel {
                results.append(try RepSenderNameData((id: repSenderNameModel.id,
                                                      repSender: repSenderNameModel.repSender,
                                                      sender: repSenderNameModel.sender,
                                                      isDelete: repSenderNameModel.isDelete)))
            }
        }

        return results
    }

    func findAllNotDeleted() throws -> [RepSenderNameData] {
        var results: [RepSenderNameData] = []

        let whereCond = NSPredicate(format: "isDelete = 0")
        let objects = try realmManager.getObjects(table: ParserRepSenderNameModel.self, cond: whereCond)

        for obj in objects {
            if let repSenderNameModel = obj as? ParserRepSenderNameModel {
                results.append(try RepSenderNameData((id: repSenderNameModel.id,
                                                      repSender: repSenderNameModel.repSender,
                                                      sender: repSenderNameModel.sender,
                                                      isDelete: repSenderNameModel.isDelete)))
            }
        }

        return results
    }

    func save(all repSenderNames: [RepSenderNameData]) {
        for repSenderName in repSenderNames {
            let repSenderNameModel = ParserRepSenderNameModel()
            repSenderNameModel.id = repSenderName.id
            repSenderNameModel.repSender = repSenderName.repSender
            repSenderNameModel.sender = repSenderName.sender
            repSenderNameModel.isDelete = repSenderName.isDelete

            realmManager.saveObject(obj: repSenderNameModel, onDuplicateKeyUpdate: true)
        }
    }
}
