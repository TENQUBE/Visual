//
//  ParsingResultModel.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

class ParserParsingResultModel: Object {
    @objc dynamic var sender: String = ""
    @objc dynamic var regRuleId: Int = 0

    override static func primaryKey() -> String? {
        return "sender"
    }
}
