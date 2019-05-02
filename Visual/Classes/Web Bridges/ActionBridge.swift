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
                var csvText = "날짜,상태,금액,내역,결제수단,카테고리,메모\n"
                for tran in transactions {
                    let transaction = tran.transaction
                    let card = tran.card
                    let category = tran.category

                    print("tran", tran)
                    
                    let date = transaction.spentDate
                    let state = transaction.spentMoney < 0 ? "취소" : "승인"
                    let amount = abs(transaction.spentMoney)
                    let keyword = transaction.keyword.replacingOccurrences(of: ",", with: " ")
                    let payment = card.changeName
                    let large = category.large
                    let memo = transaction.memo
                    
                    let newLine = "\(date),\(state),\(amount),\(keyword),\(payment),\(large),\(memo)\n"
                    csvText.append(contentsOf: newLine)

                }

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
