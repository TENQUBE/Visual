//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct SearchCompanyRequest: Codable {
    
    let transactions: [SearchInfo]
    
    
    init(transactions: [SearchInfo]) {
        self.transactions = transactions
    }
 
}

public struct SearchInfo: Codable {
    
    let id: String
    
    let keyword: String
    
    let type: String
    
    let at: String
    
    let method: String
    
    let amount: Double
    
    let amountType: String
    
    let lat: Double
    
    let long: Double
    
    var lCode: Int?
    
    var mCode: Int?
    
    
    init(id: String, keyword: String, type: String, at: String, method: String, amount: Double, amountType:String, lat:Double, long: Double, lCode: Int?, mCode: Int?) throws {
        self.id = id
        self.keyword = keyword
        self.type = type
        self.at = at
        self.method = method
        self.amount = amount
        self.amountType = amountType
        self.lat = lat
        self.long = long
        self.lCode = lCode
        self.mCode = mCode
    }
    
    
}
