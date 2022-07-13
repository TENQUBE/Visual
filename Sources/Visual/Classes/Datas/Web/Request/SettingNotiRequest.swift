//
//  BudgetRequest.swift
//  Visual
//
//  Created by tenqube on 02/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct SettingNotiRequest: Codable, DataProtocol {
    
    let name: String
    let enabled: Bool
   
    func checkParams() throws {
        
    }
}
