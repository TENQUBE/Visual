//
//  SystemBridge.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import UIKit
//import VisualParserTransaction

class ActionBridge: BaseBridge, ActionProtocol {
    
    var view: UIContractor?
    var visualRepository: VisualRepo?
    var parser: ParserProtocol?
    var syncTranRepository: SyncTranRepo?
    var analysisRepository: AnalysisRepo?
    
    var isDoing = false
    init(webView: WebViewProtocol,
         view: UIContractor,
         visualRepository: VisualRepo,
         parser: ParserProtocol,
         syncTranRepository: SyncTranRepo,
         analysisRepository: AnalysisRepo) {
        
        super.init(webView: webView)
        self.view = view
        self.visualRepository = visualRepository
        self.parser = parser
    
        self.syncTranRepository = syncTranRepository
        self.analysisRepository = analysisRepository
    }
    
    func requestSmsRecognition(_ params: String) {
        print("requestSmsRecognition")
    }
    
    func reloadSms(_ params: String) {
        print("reloadSms")
        analysisRepository?.clearCache()
    }
    
    func parseSMS(_ callback: String) {
        print("parseSMS", callback)
        
//        do {
            // 복사된 string 가져오기
            // parser.parse(fullSms, 콜백)
            // 내역 저장
            // 저장후 tranid 리턴
       
        guard let fullSms = UIPasteboard.general.string,
            !fullSms.isEmpty else {
                let alert = UIAlertController(title: "복사된 내용이 없습니다.", message: "", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){(_) in
                    
                }
                
                alert.addAction(action)
                
                self.view?.show(alert: alert, animated: false, completion: {
                    
                })
                return
        }
   
        if self.isDoing {
            
            return
        }
        self.isDoing = true
        
        let fullSmses = fullSms.components(separatedBy: "[Web발신]")
        print(fullSmses)

        self.parser?.createTransactions(fullSmses) { (err, parsedTransactions) in

            print(parsedTransactions)
            
            self.visualRepository?.insertTransactions(transactions: parsedTransactions, callback: { (tranIds) in

                
                self.analysisRepository?.clearCache()
                self.syncTranRepository?.syncTransaction()
                self.isDoing = false
//                UIPasteboard.general.string = ""
                super.callback(callback: callback, obj: ParseSMSResponse(tranIds: tranIds, fullSms: fullSms))
            })

        }

    }
    
    func exportExcel(_ callback: String) {
        print("exportExcel", callback)
        
         do {
            
            if callback.isEmpty {

                throw ParameterError.invalidValue(type: "callback", name: "is empty")
            }
        
            let fileName = "Visual.csv"
            
            let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            self.visualRepository?.getTransactions(callback: { (transactions) in
                var csvText = "id,identifier,cardId,userCategoryId,companyId,companyName,companyAddress,code,spentDate,finishDate,lat,lng,spentMoney,oriSpentMoney,installmentCnt,keyword,searchKeyword,repeatType,currency,dwType,fullSms,smsDate,smsType,regId,isOffset,isCustom,isUserUpdate,isUpdateAll,memo,classCode,isSynced,cardName,cardType,cardSubType,cardChangeName,cardChangeType,cardChangeSubType,billingDay,balance,cardMemo,cardIsExcept,cateIsExcept,large,medium,small"
                for tran in transactions {
                    let transaction = tran.transaction
                    let card = tran.card
                    let userCate = tran.userCate
                    let category = tran.category

                    print("tran", tran)
                    
                    let newLine = "\(transaction.id),\(transaction.identifier),\(transaction.cardId),\(transaction.userCategoryId),\(transaction.companyId),\(transaction.companyName),\(transaction.companyAddress),\(transaction.code),\(transaction.spentDate),\(transaction.finishDate),\(transaction.lat),\(transaction.lng),\(transaction.spentMoney),\(transaction.oriSpentMoney),\(transaction.installmentCnt),\(transaction.keyword),\(transaction.searchKeyword),\(transaction.repeatType),\(transaction.currency),\(transaction.dwType),\(String(describing: transaction.fullSms)),\(String(describing: transaction.smsDate)),\(transaction.smsType),\(transaction.regId),\(transaction.isOffset),\(transaction.isCustom),\(transaction.isUserUpdate),\(transaction.isUpdateAll),\(transaction.memo),\(transaction.classCode),\(transaction.isSynced),\(card.name),\(card.type),\(card.subType),\(card.changeName),\(card.changeType),\(card.changeSubType),\(card.billingDay),\(card.balance),\(card.memo),\(card.isExcept),\(userCate.isExcept),\(category.large),\(category.medium),\(category.small)"

                    csvText.append(contentsOf: newLine)

                }
                
                print("csvText", csvText)

                do {
                    try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
                    
                    self.view?.export(path: path)
                    
                    super.callback(callback: callback, obj: Success(success: true))
                } catch {
                    
                    super.callback(callback: callback, obj: Success(success: false))
                }
                
            })

            
        } catch {
            super.callback(callback: callback, obj: Success(success: false))
        }
        
    }
    
}
