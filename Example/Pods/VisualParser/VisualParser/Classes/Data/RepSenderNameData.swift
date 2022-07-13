//
//  RepSenderNameData.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/28.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct RepSenderNameData {
    public let id: Int
    public let repSender: String
    public let sender: String
    public let isDelete: Int

    public init(_ params: RepSenderNameParams) throws {
        try Validation.shared.validate(params)

        self.id = params.id!
        self.repSender = params.repSender!
        self.sender = params.sender!
        self.isDelete = params.isDelete!
    }
}
