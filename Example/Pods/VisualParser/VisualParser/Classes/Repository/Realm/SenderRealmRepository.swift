//
//  RepSenderRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

class SenderRealmRepository: RealmRepository, SenderRepository {
    func findAll() throws -> [SenderData] {
        var results: [SenderData] = []

        let objects = try realmManager.getObjects(table: ParserSenderModel.self)

        for obj in objects {
            if let senderModel = obj as? ParserSenderModel {
                results.append( try SenderData((senderId: senderModel.senderId,
                                                smsType: senderModel.smsType,
                                                sender: senderModel.sender,
                                                repSender: senderModel.repSender,
                                                isDelete: senderModel.isDelete)))
            }
        }

        return results
    }

    func find(by smsType: Int, _ sender: String) throws -> SenderData? {
        let whereCond = NSPredicate(format: "isDelete = 0 AND smsType = \(smsType) AND sender = %@", sender)
        guard let obj = try realmManager.getObjects(table: ParserSenderModel.self, cond: whereCond).first,
            let senderModel = obj as? ParserSenderModel else {
                return nil
        }

        return try SenderData((senderId: senderModel.senderId,
                               smsType: senderModel.smsType,
                               sender: senderModel.sender,
                               repSender: senderModel.repSender,
                               isDelete: senderModel.isDelete))
    }

    func save(all senders: [SenderData]) {
        for sender in senders {
            let senderModel = ParserSenderModel()
            senderModel.senderId = sender.senderId
            senderModel.smsType = sender.smsType
            senderModel.sender = sender.sender
            senderModel.repSender = sender.repSender
            senderModel.isDelete = sender.isDelete

            realmManager.saveObject(obj: senderModel, onDuplicateKeyUpdate: true)
        }
    }
}
