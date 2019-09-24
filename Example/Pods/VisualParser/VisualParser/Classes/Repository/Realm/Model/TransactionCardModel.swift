//
//  TransactionCardModel.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

import RealmSwift

class TransactionCardModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var num: String = ""
    @objc dynamic var type: Int = 0
    @objc dynamic var subType: Int = 0
    @objc dynamic var balance: Double = 0.0

    override static func primaryKey() -> String? {
        return "id"
    }
}
