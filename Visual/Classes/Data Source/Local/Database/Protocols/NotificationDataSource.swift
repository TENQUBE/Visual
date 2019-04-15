//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation

protocol NotificationDataSource {
    
    func findAll() throws -> [ReportNotification]
    
    func find(by name: String) throws -> [ReportNotification]
    
    func save(_ elements: [ReportNotification]) throws
    
    func edit(elements: [ReportNotification]) throws
    
}
