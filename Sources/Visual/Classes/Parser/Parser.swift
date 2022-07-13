//
//  VisualRepository.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation
import VisualParser

class Parser: ParserProtocol {
 
    let udfManager: UserDefaultsManager// local data
    let appExecutor: AppExecutors
    let parserApi: ParserAPI
    var parserService: ParserService?
    
    init(udfManager: UserDefaultsManager, appExecutor: AppExecutors, parserApi: ParserAPI) {
        self.udfManager = udfManager
        self.appExecutor = appExecutor
        self.parserApi = parserApi
    }
    
    private func createParser() throws -> ParserService?  {
        
        guard let secretKey = self.udfManager.pref.string(forKey: Constants.UDFKey.SecretKey)
            else {
                print("createParser: nil")
                return nil
        }
 
        return try ParserService(parserAPI: self.parserApi, secretKey: secretKey)
    }
    
    public func getRuleVersion() throws -> Int {
        if(self.parserService == nil) {
            self.parserService = try self.createParser()
        }
        
        return try self.parserService?.getParserVersion() ?? 0
    }
    
    public func saveParserData(parserData: ParserResponse) throws {
        
        var regRules = [RegRuleData]()
        for reg in parserData.regDatas {
            do {
                let regData = try RegRuleData((
                    regId: reg.regId,
                    repSender: reg.sender,
                    regExpression: reg.regExpression,
                    cardName: reg.cardName,
                    cardType: reg.cardType,
                    cardSubType: reg.cardSubType,
                    cardNum: reg.cardNum,
                    spentMoney: reg.spentMoney,
                    spentDate: reg.spentDate,
                    keyword: reg.keyword,
                    installmentCount: reg.installmentCount,
                    dwType: reg.dwType,
                    isCancel: reg.isCancel,
                    currency: reg.currency,
                    balance: reg.balance,
                    userName: reg.userName,
                    smsType: reg.smsType,
                    isDelete: reg.isDelete,
                    priority: reg.priority
                    
                ))
                
                regRules.append(regData)
            } catch {
                continue
            }
        }
       
        var senders = [SenderData]()
        
        for sender in parserData.senders {
            do {
        
                let senderData = try SenderData((
                    senderId: sender.senderId,
                    smsType: sender.smsType,
                    sender: sender.sender,
                    repSender: sender.repSender,
                    isDelete: sender.isDelete
                ))
                
                senders.append(senderData)
            } catch {
                continue
            }
        }

        var repSenders = [RepSenderNameData]()
        
        for rep in  parserData.repSenderMaps {
            do {
                
                let repSenderData = try RepSenderNameData((
                    id: rep.id,
                    repSender: rep.repSender,
                    sender: rep.sender,
                    isDelete: rep.isDelete
                ))
                
                repSenders.append(repSenderData)
            } catch {
                continue
            }
        }
        
        
        let parserData = ParserData(regRuleVersion: parserData.ruleVersion,
                                    regRules: regRules,
                                    senders: senders,
                                    repSenderNames: repSenders)
        
        if(self.parserService == nil) {
            self.parserService = try self.createParser()
        }
        
        try self.parserService?.saveParserData(parserData: parserData)
        
    }
    
    public func createTransactions(_ fullSmses: [String],
                                   completion: @escaping (Error?, [ParsedTransactionData]) -> Void) {
    
        self.appExecutor.diskIO.async {
            
            do {
                if(self.parserService == nil) {
                    self.parserService = try self.createParser()
                }
                
                self.parserService?.createTransactions(fullSmses, completion: { (err, trans) in
                    
                    let transactions = trans.map {
                        
                        ParsedTransactionData(
                            regRuleId: $0.regRuleId,
                            cardName: $0.cardName,
                            cardNum: $0.cardNum,
                            cardType: $0.cardType,
                            cardSubType: $0.cardSubType,
                            cardBalance: $0.cardBalance,
                            spentMoney: $0.spentMoney,
                            oriSpentMoney: $0.oriSpentMoney,
                            spentDate: $0.spentDate,
                            installmentCount: $0.installmentCount,
                            keyword: $0.keyword,
                            dwType: $0.dwType,
                            currency: $0.currency,
                            finishDate: $0.finishDate,
                            identifier: $0.identifier,
                            isOffSet: $0.isOffSet,
                            isDuplicate: $0.isDuplicate,
                            memo: $0.memo,
                            spentLatitude: $0.spentLatitude,
                            spentLongitude: $0.spentLongitude,
                            isSuccess: $0.isSuccess,
                            isCurrentTran: $0.isCurrentTran,
                            categoryCode: $0.categoryCode,
                            companyId: $0.companyId,
                            companyName: $0.companyName,
                            companyAddress: $0.companyAddress,
                            classCode: $0.classCode,
                            isPopUpCompanyName: $0.isPopUpCompanyName,
                            fullSms: ""
                        )
                    }
                    
                    self.appExecutor.mainThread.async {
                        completion(err, transactions)
                    }
                })
            } catch {
                print(error)
                self.appExecutor.mainThread.async {
                    completion(error, [])
                }
            }
        }
        
 
    }
    
}
