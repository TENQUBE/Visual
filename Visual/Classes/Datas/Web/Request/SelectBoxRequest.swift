//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct SelectBoxRequest: Codable, DataProtocol {
    
    let title: String
    let selectedColor: String
    
    let data: [SelectBoxInfo]
    
    let dataCallbackJS: String
    
    func checkParams() throws {
        
    }
}

struct SelectBoxInfo: Codable {
    let name: String
    let orderByType: Int
    let isSelected: Bool
    
    
    
}
