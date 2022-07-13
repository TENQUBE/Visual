//
//  RepositoryProtocol.swift
//  Visual
//
//  Created by tenqube on 26/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol RepositoryProtocol: JSExport {
    
    func getCategories(_ callback: String)
    
    func getCards(_ callback: String)
    
    func getTransactions(_ callback: String)
    
    func getTransactionsByIds(_ callback: String)
    
    func getLv0Contents(_ callback: String)
    
    func insertTransaction(_ params: String)
    
    func updateTransaction(_ params: String)
    
    func deleteTransactions(_ params: String)
    
    func shouldShowTranPopup() -> Bool
    
    func setTranPopup(_ shouldShow: Bool)
    
    func settingNotification(_ params: String)
    
    func getNotificationSettings(_ callback: String)
    
    func setBudget(_ params: String)
    
    func getBudget(_ params: String)
    
    func initialize(_ callback: String)
    
    func setBudgetReport(_ enabled: Bool)
    
    func isBudgetReportEnabled() -> Bool
    
    func syncResource(_ callback: String)
    
    func addPayment(_ params: String)
    
}
