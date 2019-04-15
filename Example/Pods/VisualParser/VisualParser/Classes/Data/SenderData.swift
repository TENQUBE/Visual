//
//  RepSender.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct SenderData {
    public let senderId: Int
    public let smsType: Int
    public let sender: String
    public let repSender: String
    public let isDelete: Int

    public init(_ params: SenderParams) throws {
        try Validation.shared.validate(params)

        self.senderId = params.senderId!
        self.smsType = params.smsType!
        self.sender = params.sender!
        self.repSender = params.repSender!
        self.isDelete = params.isDelete!
    }
}
