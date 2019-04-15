//
//  TransactionManagerModel.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

import RealmSwift

class TransactionManagerModel: Object {
    @objc dynamic var identifier: String = ""
    @objc dynamic var cardId: String = ""
    @objc dynamic var cardType: Int = 0
    @objc dynamic var spentMoney: Double = 0.0
    @objc dynamic var spentDate: NSDate = NSDate()
    @objc dynamic var installmentCount: Int = 0
    @objc dynamic var keyword: String = ""
    @objc dynamic var dwType: Int = 0
    @objc dynamic var isCancel: Int = 0
    @objc dynamic var categoryCode: Int = 0

    override public class func primaryKey() -> String? {
        return "identifier"
    }

    override static func indexedProperties() -> [String] {
        return ["cardId"]
    }
}
