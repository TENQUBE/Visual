//
//  UserCategory.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct ReportNotification: DataProtocol {

    let id: Int
    let name: String
    let title: String
    
    let content: String
    let ticker: String
    let alarmType: Int
    
    let dayOfWeek: Int
    let hour: Int
    let day: Int
    
    let enabled: Bool
    
    
    init(_ param: ReportNotificationParams) {
        
        self.id = param.id
        self.name = param.name
        self.title = param.title
        self.content = param.content
        self.ticker = param.ticker
        self.alarmType = param.alarmType
        self.dayOfWeek = param.dayOfWeek
        self.hour = param.hour
        self.day = param.day
        self.enabled = param.enabled
        
    }
    
    func checkParams() throws {
        
    }
}
