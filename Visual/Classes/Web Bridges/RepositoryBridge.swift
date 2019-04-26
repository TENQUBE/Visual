//
//  RepositoryBridge.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import WebKit


class RepositoryBridge: BaseBridge, RepositoryProtocol {
   
    var visualRepository: VisualRepo?
    var syncTranRepository: SyncTranRepo?
    var analysisRepository: AnalysisRepo?
    var resourceRepository: ResourceRepo?
    
    init(webView: WebViewProtocol,
         visualRepository: VisualRepo,
         syncTranRepository: SyncTranRepo,
         analysisRepository: AnalysisRepo,
         resourceRepository: ResourceRepo) {
        
        super.init(webView: webView)
        self.visualRepository = visualRepository
        self.syncTranRepository = syncTranRepository
        self.analysisRepository = analysisRepository
        self.resourceRepository = resourceRepository
    }
    
    func getCategories(_ callback: String) {
        print("getCategories", callback)
        self.visualRepository?.getCategories(callback: { (res) in
            
            guard let response = res else {
                super.callback(callback: callback, obj: Success(success: false))
                return
            }
            super.callback(callback: callback, obj: response)
        })
    }
    
    func getCards(_ callback: String) {
        
        print("getCards", callback)
        self.visualRepository?.getCards(callback: { (res) in
            
            guard let response = res else {
                print("getCards nil")
                super.callback(callback: callback, obj: Success(success: false))
                return
            }
            super.callback(callback: callback, obj: response)
        
        })
    
    }
    
    func getTransactions(_ params: String) {
        
        print("getTransactions", params)
        var request: WebTransactionRequest?

        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()

            self.visualRepository?.getTransactions(req: request!, callback: { (res) in

                guard let response = res else {
                    super.callback(callback: request!.callbackJS, obj: Success(success: false))
                    return
                }
                super.callback(callback: request!.callbackJS, obj: response)
            })


        } catch {
            guard let callback = request?.callbackJS else {
                return
            }
            super.callback(callback: callback, obj: Success(success: false))

        }
    }
    
    func getTransactionsByIds(_ params: String) {
        
        print("getTransactionsByIds", params)
        var request: TransactionByIdsRequest?
        
        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()

            self.visualRepository?.getTransactionsByIds(req: request!, callback: { (res) in

                super.callback(callback: request!.callbackJS, obj: res)
            })

        } catch {
            guard let callback = request?.callbackJS else {
                return
            }

            super.callback(callback: callback, obj: Success(success: false))
        }
    }
    
    func getLv0Contents(_ callback: String) {
        
        print("getLv0Contents", callback)
//        do {
        
        // lv0 의 경우 4개월치 데이터 뽑아서 전달함
        let date = Date()
        let year = date.getValue(componet: .year)
        let month = date.getValue(componet: .month)
        
        let req = WebTransactionRequest(year: year, month: month, before:4, callbackJS: "")
        
        self.visualRepository?.getAnalysisTransactions(req: req, callback: { (res) in
            
            if res.count == 0 {
                let contents = Lv0Content(items: [])
                super.callback(callback: callback, obj: contents)
            } else {
                self.analysisRepository?.loadAnalysisList(req: res, callback: { (res) in
                    print("res",res)
                    let contents = Lv0Content(items: res)
                    super.callback(callback: callback, obj: contents)
                })
            }
       
            
            
        })
           
//        } catch {
//            super.callback(callback: callback, obj: Success(success: false))
//        }
    }
    
    func insertTransaction(_ params: String) {
        
        print("insertTransaction", params)
        var request: InsertTransactionRequest?
    
        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()
            
            self.visualRepository?.insertTransaction(req: request!, callback: { (res) in

                guard let _ = res else {
                    super.callback(callback: request!.callbackJS, obj: Success(success: false))
                    return
                }
                
                self.analysisRepository?.clearCache()
                self.syncTranRepository?.syncTransaction()
                
                super.callback(callback: request!.callbackJS, obj: Success(success: true))

            })

        } catch {
            guard let callback = request?.callbackJS else {
                return
            }
            
            super.callback(callback: callback, obj: Success(success: false))
        }
    }
    
    func updateTransaction(_ params: String) {
        print("updateTransaction", params)

        var request: MergeTransactionRequest?

        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()
            
            self.visualRepository?.updateTransaction(req: request!, callback: { (suc) in
                
                if suc{
                    self.analysisRepository?.clearCache()
                    self.syncTranRepository?.syncTransaction()
                }

                 super.callback(callback: request!.callbackJS, obj: Success(success: suc))
            })

           
        } catch {
            guard let callback = request?.callbackJS else {
                return
            }

            super.callback(callback: callback, obj: Success(success: false))
        }
    }
    
    func deleteTransactions(_ params: String) {
        
        print("deleteTransactions", params)
        var request: DeleteTransaction?

        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()
            self.visualRepository?.deleteTransaction(req: request!, callback: {
                
                self.syncTranRepository?.syncTransaction()
                self.analysisRepository?.clearCache()

                super.callback(callback: request!.callbackJS, obj: Success(success: $0))
            })

        } catch {
            guard let callback = request?.callbackJS else {
                return
            }

            super.callback(callback: callback, obj: Success(success: false))
        }
        
    }
    
    func shouldShowTranPopup() -> Bool {
        
        print("shouldShowTranPopup")
        return self.visualRepository!.shouldShowTranPopup()
    }
    
    func setTranPopup(_ shouldShow: Bool) {
        
        print("setTranPopup")
        self.visualRepository?.setTranPopup(shouldShow)
    }

    func initialize(_ callback: String) {
        
        print("initialize")
        
        self.visualRepository?.updateIsDeleted(callback: { (res) in
            
            self.syncTranRepository?.syncTransaction()
            self.analysisRepository?.clearCache()

            self.visualRepository?.initialize(callback: { (res) in
               
                super.callback(callback: callback, obj: Success(success: res))
                
            })
        })
    }
    

    func settingNotification(_ params: String) {
        
        print("settingNotification", params)

//        var request: SettingNotiRequest?
//
//        do {
//            request = try Utill.decodeJSON(from: params)
//            try request!.checkParams()
//
//            self.visualRepository?.settingNotification(req: request!, callback: { (suc) in
////                super.callback(callback: request!.callbackJS, obj: Success(success: suc))
//            })
//
//        } catch {
////            guard let callback = request?.callbackJS else {
////                return
////            }
////
////            super.callback(callback: callback, obj: Success(success: false))
//        }
        
    }
    
    func getNotificationSettings(_ callback: String) {
         print("getNotificationSettings")
  
//        self.visualRepository?.getNotificationSettings(callback: { (res) in
//            
//            guard let response = res else {
//                
//                super.callback(callback: callback, obj: Success(success: false))
//                return
//            }
//            
//            super.callback(callback: callback, obj: response)
//        })
//        

    }
    
    
    
    func setBudget(_ params: String) {
        print("setBudget", params)
        
//        var request: BudgetRequest?
//
//        do {
//            request = try Utill.decodeJSON(from: params)
//            try request!.checkParams()
//
//            //            self.visualRepository?.mergeBudget(req: request!, callback: { (suc) in
//            //                super.callback(callback: request!.callbackJS, obj: Success(success: suc))
//            //            })
//
//        } catch {
//            guard let callback = request?.callbackJS else {
//                return
//            }
//
//            super.callback(callback: callback, obj: Success(success: false))
//        }
    }
    
    
    func getBudget(_ callback: String) {
        
        print("getBudget")
//        do {
//
//            //            self.visualRepository?.getBudget(callback: { (res) in
//            //
//            //                guard let response = res else {
//            //                    super.callback(callback: callback, obj: Success(success: false))
//            //                    return
//            //                }
//            //                super.callback(callback: callback, obj: response)
//            //            })
//
//        } catch {
//            super.callback(callback: callback, obj: Success(success: false))
//        }
    }
    
    func setBudgetReport(_ enabled: Bool) {
        
        //        self.visualRepository.setBudgetReport(enabled: enabled)
        print("setBudgetReport")
    }
    
    func isBudgetReportEnabled() -> Bool {
        print("isBudgetReportEnabled")
        
        //        return self.visualRepository.isBudgetReportEnabled()
        
        return false
    }
    
    func syncResource(_ callback: String) {
        print("syncResource")
        
        self.visualRepository?.generateDatas(callback: { (suc) in
            self.analysisRepository?.generateDatas(callback: { (suc2) in
                let success = suc && suc2
                print("success", success)
                
                super.callback(callback: callback, obj: Success(success: success))
                
                self.resourceRepository?.sync()
                
            })
        })
    }
    
}
