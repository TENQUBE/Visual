//
//  Advertisement.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct Currency: DataProtocol {
    let id: Int
    let from: String
    let to: String
    let rate: Double
    let createdAt: String
    
    init(_ param: CurrencyParams) {
        
        self.id = param.id
        self.from = param.from
        self.to = param.to
        self.rate = param.rate
        self.createdAt = param.createdAt
        
    }
    
    func checkParams() throws {
        
    }
}
