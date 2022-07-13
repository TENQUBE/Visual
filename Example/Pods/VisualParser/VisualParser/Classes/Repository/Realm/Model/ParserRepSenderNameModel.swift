//
//  ParserRepSenderNameModel.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/28.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

class ParserRepSenderNameModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var repSender: String = ""
    @objc dynamic var sender: String = ""
    @objc dynamic var isDelete: Int = 0

    override static func primaryKey() -> String? {
        return "id"
    }
}
