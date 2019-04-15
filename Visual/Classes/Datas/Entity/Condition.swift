//
//  Advertisement.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation
public struct Condition: DataProtocol {
 
    let id: Int
    let cId: Int
    let standard: String
    let funcType: String
    let funcKeys: String
    
    init(_ param: ConditionParams) {
        
        self.id = param.id
        self.cId = param.cId
        self.standard = param.standard
        self.funcType = param.funcType
        self.funcKeys = param.funcKeys
        
    }
    
    func checkParams() throws {
        
    }
}
