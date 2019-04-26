//
//  VisualRepo.swift
//  Visual
//
//  Created by tenqube on 27/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol VisualRepo {
    
    func signOut(callback: @escaping (Bool) -> ())
    
    func saveApiKey(apiKey: String)
    
    func saveLayer(layer: String)
    
    func getWebUrl() -> String
    
    func generateDatas(callback: @escaping (Bool) -> ())
    
    func getCategories(callback: @escaping (_ res: CategoryResponse?)->())
    
    func getCards(callback: @escaping (_ res: CardResponse?)->())
    
    func getAnalysisTransactions(req: WebTransactionRequest, callback: @escaping (_ res: [JoinedTransaction])->())
    
    func getTransactions(callback: @escaping (_ res: [JoinedTransaction])->())
    
    func getTransactions(req: WebTransactionRequest, callback: @escaping (_ res: TransactionResponse?)->())
    
    func getTransactionsByIds(req: TransactionByIdsRequest, callback: @escaping (_ res: TransactionResponse?)->())
    
    func insertTransactions(transactions: [ParsedTransactionData], callback: @escaping ([Int]) -> ())
    
    func insertTransaction(req: InsertTransactionRequest, callback: @escaping(_ res: Int?)->())
    
    func updateTransaction(req: MergeTransactionRequest, callback: @escaping(_ res: Bool)->())
    
    func deleteTransaction(req: DeleteTransaction, callback: @escaping(_ res: Bool)->())
    
    func shouldShowTranPopup() -> Bool

    func setTranPopup(_ shouldShow: Bool)
    
    func setBudget(_ req: BudgetRequest)
    
    func getBudget(_ callback: String)
    
    func updateIsDeleted(callback: @escaping(_ res: Bool)->())
    
    func initialize(callback: @escaping(_ res: Bool)->())
    
    func setBudgetReport(_ enabled: Bool)
    
    func isBudgetReportEnabled() -> Bool
    
//    func settingNotification(req: SettingNotiRequest, callback: @escaping(_ res: Bool)->())
    
//    func getNotificationSettings(callback: @escaping(_ res: SettingNotiResponse?)->())
    
}
