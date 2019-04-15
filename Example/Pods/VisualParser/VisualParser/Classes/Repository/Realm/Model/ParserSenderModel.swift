//
//  RepSenderModel.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

class ParserSenderModel: Object {
    @objc dynamic var senderId: Int = 0
    @objc dynamic var smsType: Int = 0
    @objc dynamic var sender: String = ""
    @objc dynamic var repSender: String = ""
    @objc dynamic var isDelete: Int = 0

    override public class func primaryKey() -> String? {
        return "senderId"
    }
}
