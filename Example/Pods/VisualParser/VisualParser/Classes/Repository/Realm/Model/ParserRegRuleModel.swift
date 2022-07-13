//
//  RegRuleModel.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

class ParserRegRuleModel: Object {
    @objc dynamic var regId: Int = 0
    @objc dynamic var repSender: String = ""
    @objc dynamic var regExpression: String = ""
    @objc dynamic var cardName: String = ""
    @objc dynamic var cardType: String = ""
    @objc dynamic var cardSubType: String = ""
    @objc dynamic var cardNum: String = ""
    @objc dynamic var spentMoney: String = ""
    @objc dynamic var spentDate: String = ""
    @objc dynamic var keyword: String = ""
    @objc dynamic var installmentCount: String = ""
    @objc dynamic var dwType: String = ""
    @objc dynamic var isCancel: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var balance: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var smsType: Int = 0
    @objc dynamic var isDelete: Int = 0
    @objc dynamic var priority: Int = 0

    override static func primaryKey() -> String? {
        return "regId"
    }
}
