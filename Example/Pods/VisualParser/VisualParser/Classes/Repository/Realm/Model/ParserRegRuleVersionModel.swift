//
//  RegRuleVersionModel.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

class ParserRegRuleVersionModel: Object {
    @objc dynamic var id: Int = DefaultRegVersion.id.rawValue
    @objc dynamic var version: Int = DefaultRegVersion.version.rawValue
    @objc dynamic var updateAt: NSDate = NSDate()

    override static func primaryKey() -> String? {
        return "id"
    }
}
