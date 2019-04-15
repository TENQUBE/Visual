//
//  RegRuleVersion.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct RegRuleVersionData {
    public let version: Int
    public let updateAt: Date

    public init(_ version: Int, _ updateAt: Date) {
        self.version = version
        self.updateAt = updateAt
    }
}
