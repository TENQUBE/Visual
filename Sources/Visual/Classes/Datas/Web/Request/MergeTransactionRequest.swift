//
//  InsertTranRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct MergeTransactionRequest: Codable, DataProtocol {
    
    let id: Int
    let lCode: Int
    let mCode: Int
    let cateConfigId: Int
    let keyword: String
    let amount: Double
    let cardId: Int
    let installmentCnt: Int
    let date: String
    let memo: String
    let isExpense: Bool
    let isAll: Bool
    let callbackJS: String
    
    func checkParams() throws {
        
        if date.toDate() == nil {
            throw ParameterError.invalidValue(type: "not date", name: "date error \(self.date)")
        }
        
        if(lCode == 0 || cardId == 0 || installmentCnt == 0 || cateConfigId == 0) {
            throw ParameterError.invalidValue(type: "not zero", name: "lCode == 0 || cardId == 0 || installmentCnt == 0")
        }
        
        if(keyword.count > 100) {
            throw ParameterError.invalidValue(type: "lenth . 100", name: keyword)
        }
        
        if(memo.count > 300) {
            throw ParameterError.invalidValue(type: "lenth . 300", name: memo)
        }
    }

    
}
