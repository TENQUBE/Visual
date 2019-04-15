//
//  Advertisement.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct Card: DataProtocol {
    
    let id: Int
    let name: String
    let type: Int
    let subType: Int
    let changeName: String
    let changeType: Int
    let changeSubType: Int
    let billingDay: Int
    let balance: Double
    let memo: String
    let isExcept: Bool
    let isCustom: Bool
    let isDeleted: Bool
    
    init(_ param: CardParams) {
        
        self.id = param.id
        self.name = param.name
        self.type = param.type
        self.subType = param.subType
        self.changeName = param.changeName
        self.changeType = param.changeType
        self.changeSubType = param.changeSubType
        self.billingDay = param.billingDay
        self.balance = param.balance
        self.memo = param.memo
        self.isExcept = param.isExcept
        self.isCustom = param.isCustom
        self.isDeleted = param.isDeleted
        
    }
    
    func checkParams() throws {
        
    }
}
