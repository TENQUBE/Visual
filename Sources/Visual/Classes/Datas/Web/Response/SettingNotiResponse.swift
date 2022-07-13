//
//  BudgetRequest.swift
//  Visual
//
//  Created by tenqube on 02/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

struct SettingNotiResponse: Codable, DataProtocol {
    
    let settings: [SettingNoti]
    
    func checkParams() throws {
        
    }
}

struct SettingNoti: Codable {
    let name: String
    let enabled: Bool
    let hour: Int
    
    init (name: String, enabled: Bool, hour: Int) {
        self.name = name
        self.enabled = enabled
        self.hour = hour
        
    }
    
}
