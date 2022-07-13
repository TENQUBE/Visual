//
//  SyncRepository.swift
//  Visual
//
//  Created by tenqube on 04/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

import Foundation


class SyncTranRepository: SyncTranRepo {
    
    let appExecutor: AppExecutors
    
    let categoryDao: CategoryDataSource
    let userCateDao: UserCategoryDataSource
    
    let cardDao: CardDataSource
    
    let tranDao: TransactionDataSource
    
    let visualApi: VisualApiService
    
    var requests = [TransactionRequest]()
    
    init(appExecutor: AppExecutors,
         categoryDao: CategoryDataSource,
         userCateDao: UserCategoryDataSource,
         cardDao: CardDataSource,
         tranDao: TransactionDataSource,
         visualApi: VisualApiService) {
        
        self.appExecutor = appExecutor
        self.categoryDao = categoryDao
        self.userCateDao = userCateDao
        self.cardDao = cardDao
        self.tranDao = tranDao
        self.visualApi = visualApi
    }
    
    func syncTransaction() {
        self.appExecutor.diskIO.async {
            
            do {
                let transactions = try self.tranDao.find(by: false)
                
                let cardIds = transactions.map {
                    $0.cardId
                }
                
                let distinctCardIds = Array(Set(cardIds))
                
                let cards = try self.cardDao.find(by: distinctCardIds)
                
                let cardDict = Dictionary(uniqueKeysWithValues: cards.map{ ($0.id, $0) })
                
                var serverTransactions = [ServerTransaction]()
                for tran in transactions {
                    guard let card = cardDict[tran.cardId] else {
                        continue
                    }
                    
                    do {
                        let serverTran = try ServerTransaction(transaction: tran, card: card)
                        serverTransactions.append(serverTran)
                        
                        if serverTransactions.count == 30 {
                            let request = TransactionRequest(transactions: serverTransactions)
                            self.requests.append(request)
                            serverTransactions.removeAll()
                            self.sendToServer()
                        }
                        
                    } catch {
                        
                        print("parameter error", tran, card)
                    }
                    
                }
                
                if serverTransactions.count != 0 {
                    let request = TransactionRequest(transactions: serverTransactions)
                    self.requests.append(request)
                    self.sendToServer()
                    
                }
                
                
            } catch {
                
            }
            
        }
    }
    
    
    private func sendToServer() {//
        if let req = self.requests.first {
            
            self.visualApi.saveTransactions(request: req) { (res, error) in
                
                // 업데이트
                do  {
                    
                    if error == nil {
                        
                        let identifiers = req.transactions.map{
                            Int64($0.identifier)!
                        }
                        
                        let transactions = try self.tranDao.find(by: identifiers)
                        
                        let results = transactions.map {
                            
                            Transaction((
                                id : $0.id,
                                identifier : $0.identifier,
                                cardId : $0.cardId,
                                userCategoryId : $0.userCategoryId,
                                companyId : $0.companyId,
                                companyName : $0.companyName,
                                companyAddress : $0.companyAddress,
                                code : $0.code,
                                spentDate : $0.spentDate,
                                finishDate : $0.finishDate,
                                lat : $0.lat,
                                lng : $0.lng,
                                spentMoney : $0.spentMoney,
                                oriSpentMoney : $0.oriSpentMoney,
                                installmentCnt : $0.installmentCnt,
                                keyword : $0.keyword,
                                searchKeyword : $0.searchKeyword,
                                repeatType : $0.repeatType,
                                currency : $0.currency,
                                isDeleted : $0.isDeleted,
                                dwType : $0.dwType,
                                smsType : $0.smsType,
                                fullSms : $0.fullSms,
                                smsDate : $0.smsDate,
                                
                                regId : $0.regId,
                                isOffset : $0.isOffset,
                                isCustom : $0.isCustom,
                                isUserUpdate : $0.isUserUpdate,
                                isUpdateAll : $0.isUpdateAll,
                                memo : $0.memo,
                                classCode : $0.classCode,
                                isSynced : true,
                                isPopUpCompanyName : $0.isPopUpCompanyName
                                
                            ))
                        }
                        
                        try self.tranDao.edit(results)
                        if self.requests.count != 0 {
                            self.requests.removeFirst()
                        }
                        self.sendToServer()
                        
                        
                    }
                    
                    
                } catch {
                    
                }
                
            }
            
        }
        
    }
    
    
    
}

