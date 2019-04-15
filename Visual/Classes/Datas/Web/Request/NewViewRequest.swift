//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct NewViewRequest: Codable, DataProtocol {
    
    let viewType: String
    let url: String

   
    func checkParams() throws {
        
    }
}

