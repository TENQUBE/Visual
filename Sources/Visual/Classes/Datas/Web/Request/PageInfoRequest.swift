//
//  TransactionRequest.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct PageInfoRequest: Codable, DataProtocol {
    
    let name: String
    let shouldRefresh: Bool
    
    func checkParams() throws {
        
    }
}

