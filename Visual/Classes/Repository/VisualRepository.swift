//
//  VisualRepository.swift
//  Visual
//
//  Created by tenqube on 18/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation

class VisualRepository: VisualRepo {

    let udfManager: UserDefaultsManager
    let searchManager: SearchManager
    let visualApi: VisualApiService
    let cardDao: CardDataSource
    let adDao: AdvertisementDataSource
    let categoryDao: CategoryDataSource
    let currencyDao: CurrencyDataSource
    let userCateDao: UserCategoryDataSource
    let tranDao: TransactionDataSource
  
//    let budgetDao: BudgetDataSource
//    let notificationDao: NotificationDataSource
    
    let appExecutor: AppExecutors

    init(udfManager: UserDefaultsManager,
         searchManager: SearchManager,
         visualApi: VisualApiService,
         cardDao: CardDataSource,
         adDao: AdvertisementDataSource,
         categoryDao: CategoryDataSource,
         currencyDao: CurrencyDataSource,
         userCateDao: UserCategoryDataSource,
         tranDao: TransactionDataSource,
//         budgetDao: BudgetDataSource,
//         notificationDao: NotificationDataSource,
         appExecutor: AppExecutors) {

        self.udfManager = udfManager
        self.searchManager = searchManager
        self.visualApi = visualApi
        self.cardDao = cardDao
        self.adDao = adDao
        self.categoryDao = categoryDao
        self.currencyDao = currencyDao
        self.userCateDao = userCateDao
        self.tranDao = tranDao
//        self.budgetDao = budgetDao
//        self.notificationDao = notificationDao

        self.appExecutor = appExecutor
        
    }
    
    func signOut(callback: @escaping (Bool) -> ()) {
        initialize { (suc) in
            self.udfManager.save(key: Constants.UDFKey.UID, value: "")
            callback(suc)
        }
    }
    
    
    func saveApiKey(apiKey: String) {
        self.udfManager.save(key: Constants.UDFKey.ApiKey, value: apiKey)
    }
    
    func saveLayer(layer: String) {
        self.udfManager.save(key: Constants.UDFKey.Layer, value: layer)
    }
    
    func getWebUrl() -> String {
        guard let url = self.udfManager.pref.string(forKey: Constants.UDFKey.WebUrl) else {
            return ""
        }
        return url
    }
    
    func shouldShowTranPopup() -> Bool {
        return self.udfManager.pref.bool(forKey: Constants.UDFKey.TranPopUp)
    }
    
    func setTranPopup(_ shouldShow: Bool) {
        self.udfManager.save(key: Constants.UDFKey.TranPopUp, value: shouldShow)
    }
    
    func generateDatas(callback: @escaping (Bool) -> ()) {
        
        self.appExecutor.diskIO.async {
         
            do {
                if !self.udfManager.pref.bool(forKey: Constants.UDFKey.VisualData) {
                    if let cards = DataGenerator.card.datas {
                        try self.cardDao.removeAll()
                        try self.cardDao.save(cards as! [Card])
                    }
                    
                    if let categories = DataGenerator.category.datas {
                        try self.categoryDao.removeAll()
                        try self.userCateDao.removeAll()
                        try self.categoryDao.save(categories as! [Category])
                    }
                    
                    let lcodes = try self.categoryDao.findDistinctLocdes()
                    try self.userCateDao.createData(lcodes: lcodes)
                    
                    
                    if let curruncies = DataGenerator.currency.datas {
                        try self.currencyDao.removeAll()
                        try self.currencyDao.save(curruncies as! [Currency])
                    }
                    
                    self.udfManager.save(key: Constants.UDFKey.VisualData, value: true)
                    
                    //                if let notifications = DataGenerator.notification().datas {
                    //                    try self.notificationDao.save(notifications as! [ReportNotification])
                    //                }
                    //
                    //                if let budgets = DataGenerator.budget().datas {
                    //                    try self.budgetDao.save(budgets as! [Budget])
                    //                }
                }
            
                self.appExecutor.mainThread.async {
                    callback(true)
                }
                
            } catch {
                callback(false)
            }
            
        }
    }
    
    func getCategories(callback: @escaping (CategoryResponse?) -> ())  {
        
        self.appExecutor.diskIO.async {
            
            do {
          
                let serverCategories = try self.categoryDao.findAll().map {
                    return ServerCategoryInfo(categoryId: $0.id,
                                              largeCategory: $0.large,
                                              mediumCategory: $0.medium,
                                              categoryCode: $0.code)
                }
                
                let userCategories = try self.userCateDao.findAll().map {
                    UserCategoryInfo(cateConfigId: $0.id,
                                     categoryCode: $0.code,
                                     mainType: 0,
                                     exceptType: $0.isExcept ?  1 : 0)
                }
                
                let res = CategoryResponse(server: serverCategories, user: userCategories)
                
                self.appExecutor.mainThread.async {
                    callback(res)
                }
            } catch {
                self.appExecutor.mainThread.async {
                    callback(nil)
                }
            }
        }
    }
    
    func getCards(callback: @escaping (CardResponse?) -> ()) {
        
        self.appExecutor.diskIO.async {
            
            do {
                
                let cards = try self.cardDao.findAll().map {
                    CardInfo(cardId: $0.id,
                             cardName: $0.name,
                             changeName: $0.changeName,
                             changeCardType: $0.changeType,
                             changeCardSubType: $0.changeSubType,
                             cardImgPath: "",
                             memo: $0.memo,
                             totalSum: $0.balance,
                             isExcept: $0.isExcept ? 1: 0)
                }
               
                let res = CardResponse(cards: cards)
                self.appExecutor.mainThread.async {
                    callback(res)
                }
            } catch {
                self.appExecutor.mainThread.async {
                    callback(nil)
                }
            }
        }
    }
    
    func getAnalysisTransactions(req: WebTransactionRequest, callback: @escaping ([JoinedTransaction]) -> ()) {
        
        self.appExecutor.diskIO.async {
            
            do {
                // 내역
                let transactions = try self.tranDao.find(by: req)
                
                let cardDict = try self.getCardDict(transactions: transactions)
                
                let userCateDict = try self.getUserCateDict(transactions: transactions)
                
                let categoryDict = try self.getCateDict(transactions: transactions)
                
                var results = [JoinedTransaction]()
                
                for tran in transactions {
                    guard let card = cardDict[tran.cardId],
                        let userCate = userCateDict[tran.userCategoryId],
                        let category = categoryDict[tran.code] else {
                            continue
                    }
                    
                    if(userCate.isExcept || card.isExcept) {
                        continue
                    }
                    
                    results.append(JoinedTransaction(transaction: tran,
                                      card: card,
                                      userCate: userCate,
                                      category: category))
                    
                }
    
                self.appExecutor.mainThread.async {
                    callback(results)
                }
                
            } catch {
                
                self.appExecutor.mainThread.async {
                    callback([])
                }
            }
        }
    }
    
    func getTransactions(callback: @escaping ([JoinedTransaction]) -> ()) {
        self.appExecutor.diskIO.async {
            
            do {
                // 내역
                let transactions = try self.tranDao.findAll()
                
                let cardDict = try self.getCardDict(transactions: transactions)
                
                let userCateDict = try self.getUserCateDict(transactions: transactions)
                
                let categoryDict = try self.getCateDict(transactions: transactions)
                
                var results = [JoinedTransaction]()
                
                for tran in transactions {
                    guard let card = cardDict[tran.cardId],
                        let userCate = userCateDict[tran.userCategoryId],
                        let category = categoryDict[tran.code] else {
                            continue
                    }
                    results.append(JoinedTransaction(transaction: tran, card:card, userCate: userCate, category: category))
                }
    
                self.appExecutor.mainThread.async {
                    callback(results)
                }
            } catch {
                
                self.appExecutor.mainThread.async {
                    callback([])
                }
            }
        }
    }
    
    func getTransactions(req: WebTransactionRequest, callback: @escaping (TransactionResponse?) -> ()) {
        self.appExecutor.diskIO.async {
            
            do {
                // 내역
                let transactions = try self.tranDao.find(by: req)
                print("transactions", transactions)
                let res = try self.getTransactions(transactions: transactions)
                print(res)
                self.appExecutor.mainThread.async {
                    callback(res)
                }
            } catch {
                
                self.appExecutor.mainThread.async {
                    callback(nil)
                }
            
            }
        }
    }
    
    func getTransactionsByIds(req: TransactionByIdsRequest, callback: @escaping (TransactionResponse?) -> ()) {
        
        self.appExecutor.diskIO.async {

            do {
                let transactions = try self.tranDao.find(by: req.tranIds)
                
                let res = try self.getTransactions(transactions: transactions)
               
                self.appExecutor.mainThread.async {
                    callback(res)
                }
            } catch {
                
                self.appExecutor.mainThread.async {
                    callback(nil)
                }
            }
        }
    }
    
    private func getCardDict(transactions: [Transaction]) throws -> Dictionary<Int, Card>  {
        let cardIds = transactions.map {
            $0.cardId
        }
        
        let distinctCardIds = Array(Set(cardIds))
        
        let cards = try self.cardDao.find(by: distinctCardIds)
        
        return Dictionary(uniqueKeysWithValues: cards.map{ ($0.id, $0) })
    }
    
    private func getUserCateDict(transactions: [Transaction]) throws -> Dictionary<Int, UserCategory> {
        let userCateIds = transactions.map {
            $0.userCategoryId
        }
        
        let distinctUserCateIds = Array(Set(userCateIds))
        
        let userCate = try self.userCateDao.find(by: distinctUserCateIds)
        
        return Dictionary(uniqueKeysWithValues: userCate.map{ ($0.id, $0) })
    }
    
    private func getCateDict(transactions: [Transaction]) throws -> Dictionary<Int, Category> {
        let codes = transactions.map {
            $0.code
        }
        
        let distinctCodes = Array(Set(codes))
        
        let categories = try self.categoryDao.find(by: distinctCodes)
        
        return Dictionary(uniqueKeysWithValues: categories.map{ ($0.code, $0) })
    }
    
    
    private func getTransactions(transactions: [Transaction]) throws -> TransactionResponse {
        
        let cardDict = try self.getCardDict(transactions: transactions)
        
        let userCateDict = try self.getUserCateDict(transactions: transactions)
        
        let categoryDict = try self.getCateDict(transactions: transactions)
        
        var results = [TransactionInfo]()
        
        for tran in transactions {
            guard let card = cardDict[tran.cardId],
                let userCate = userCateDict[tran.userCategoryId],
                let category = categoryDict[tran.code] else {
                    continue
            }
            
            let tran = TransactionInfo(transactionId: tran.id,
                            categoryCode: tran.code,
                            largeCategory: category.large,
                            mediumCategory: category.medium,
                            userCateConfigId: tran.userCategoryId,
                            companyId: tran.companyId,
                            franchise: tran.companyName,
                            cardId: tran.cardId,
                            changeName: card.changeName,
                            spentMoney: tran.spentMoney,
                            installmentCount: tran.installmentCnt,
                            repeatType: tran.repeatType,
                            exceptType: (card.isExcept || userCate.isExcept) ? 1 : 0,
                            dwType: tran.dwType,
                            currency: tran.currency,
                            isOffset: tran.isOffset ? 1: 0,
                            spentDate: tran.spentDate.toStr(),
                            finishDate: tran.finishDate.toStr(),
                            keyword: tran.keyword,
                            memo: tran.memo)
            
            results.append(tran)
        }
  
        
        return TransactionResponse(transactions: results)
    }
    
    func insertTransactions(transactions: [ParsedTransactionData], callback: @escaping ([Int]) -> ()) {
    
        self.appExecutor.diskIO.async {
          
            var tranIds = [Int]()
    
            for tran in transactions {

                do {
                    
                    guard let identifier = Date().toMillis(),
                        let userCate = try self.userCateDao.findByCode(code: tran.categoryCode.getUserCateCode()),
                        let _ = try self.categoryDao.find(by: tran.categoryCode)
                        else {
                            continue
                    }
                    
                    let cardName = (tran.cardName + tran.cardNum)
                  
                    let card = try self.cardDao.find(by: cardName, tran.cardType, tran.cardSubType, balance: tran.cardBalance)
                    
                    let transaction = Transaction((
                        id : 0,
                        identifier : identifier,
                        cardId : card.id,
                        userCategoryId : userCate.id,
                        companyId : tran.companyId,
                        companyName : tran.companyName,
                        
                        companyAddress : tran.companyAddress,
               
                        code : tran.categoryCode,
                        spentDate : tran.spentDate.toDate() ?? Date(),
                        finishDate : tran.finishDate.toDate() ?? Date(),
                        lat : tran.spentLatitude,
                        lng : tran.spentLongitude,
                        spentMoney : tran.spentMoney,
                        oriSpentMoney : tran.oriSpentMoney,
                        installmentCnt : tran.installmentCount,
                        keyword : tran.keyword,
                        searchKeyword : tran.keyword,
                        repeatType : 0,
                        currency : tran.currency,
                        isDeleted : false,
                        dwType : tran.dwType,
                        smsType : 2,
                        fullSms : "",
                        smsDate : Date(),
                        regId : tran.regRuleId,
                        isOffset : tran.isOffSet == 1,
                        isCustom : false,
                        isUserUpdate : false,
                        isUpdateAll : false,
                        memo : tran.currency.isEmpty ? "" : tran.currency + " " + String(tran.oriSpentMoney),
                        classCode : tran.classCode,
                        isSynced : false,
                        isPopUpCompanyName: false
                    ))
                    
                    let tranId = try self.tranDao.save(transaction)
                    print("tranId" , card)

                    tranIds.append(tranId)
                // sync transaction 추가
                    
                } catch {
                    print("error" , error)
                }
             
            }
            
            self.appExecutor.mainThread.async {
                callback(tranIds)
            }
        }
    }
    
    func insertTransaction(req: InsertTransactionRequest, callback: @escaping (Int?) -> ()) {
        self.appExecutor.diskIO.async {
            var tranId = 0
            do {
                
                let obj = try self.cardDao.find(by: req.cardId)
                
                guard let identifier = Date().toMillis(),
                let card = obj,
                let method = CardType(rawValue: card.changeSubType)?.search else {
                    self.appExecutor.mainThread.async {
                        callback(nil)
                    }
                    return
                }
                
                let searchInfo = try SearchInfo(id: String(describing: identifier),
                                                                keyword: req.keyword,
                                                                type: req.isExpense ? DwType.withdraw.str : DwType.deposit.str,
                                                                at: req.date,
                                                                method: method,
                                                                amount: Double(req.amount),
                                                                amountType: "KRW",
                                                                lat: -1,
                                                                long: -1,
                                                                lCode: req.lCode,
                                                                mCode: req.mCode)
                
                let searchReq = SearchCompanyRequest(transactions: [searchInfo])
                self.searchManager.searchCompany(reqData: searchReq, completion: { (err, response) in

                    var companyId = 0
                    var companyName = ""
                    var companyAddress = ""
                    var code = Int(String(req.lCode) + String(req.mCode) + "10") ?? (req.isExpense ? 101010: 901010)
                    var searchKeyword = req.keyword
                    var classCode = ""
                    var isPopUpCompanyName = false
                    
                    if response.results.count > 0 { // 검색 응답값
                        let tranCompany: TranCompany = response.results[0]
                        companyId = tranCompany.company.id
                        companyName = tranCompany.company.name
                        companyAddress = tranCompany.company.address
                        code = tranCompany.category.code
                        searchKeyword = tranCompany.keyword.search
                        classCode = tranCompany.classCode
                        isPopUpCompanyName = tranCompany.isPopUpCompanyName
                    }
                    
                    let transaction = Transaction((
                        id : 0,
                        identifier : identifier,
                        cardId : req.cardId,
                        userCategoryId : req.cateConfigId,
                        companyId : companyId,
                        companyName: companyName,
                        companyAddress: companyAddress,
                        code : code,
                        spentDate : req.date.toDate() ?? Date(),
                        finishDate : req.date.toDate() ?? Date(),
                        lat : -1.0,
                        lng : -1.0,
                        spentMoney : Double(req.amount),
                        oriSpentMoney : Double(req.amount),
                        installmentCnt : req.installmentCnt,
                        keyword : req.keyword,
                        searchKeyword : searchKeyword,
                        repeatType : 0,
                        currency : "",
                        isDeleted : false,
                        dwType : req.isExpense ? 1 : 0,
                        smsType : 3,
                        fullSms : nil,
                        smsDate : nil,
                        
                        regId : 0,
                        isOffset : false,
                        isCustom : true,
                        isUserUpdate : false,
                        isUpdateAll : false,
                        memo : req.memo,
                        classCode : classCode,
                        isSynced : false,
                        isPopUpCompanyName: isPopUpCompanyName
                    ))
                    
                    do {
                        tranId = try self.tranDao.save(transaction)
                        // sync transaction 추가
                        print(tranId)
                        self.appExecutor.mainThread.async {
                            callback(tranId)
                        }
                    } catch {
                        self.appExecutor.mainThread.async {
                            callback(nil)
                        }
                    }
                    
                })
             
            } catch {
                self.appExecutor.mainThread.async {
                    callback(nil)
                }
            }
        }
    }
    
    func updateTransaction(req: MergeTransactionRequest, callback: @escaping (Bool) -> ()) {
        self.appExecutor.diskIO.async {
    
            do {
                
                let cardObj = try self.cardDao.find(by: req.cardId)
                
                guard let card = cardObj, let method = CardType(rawValue: card.changeSubType)?.search else {
                    self.appExecutor.mainThread.async {
                        callback(false)
                    }
                    return
                }
                
                let oriTransactionObj = try self.tranDao.find(by: req.id)
                
                guard let oriTransaction = oriTransactionObj else {
                    self.appExecutor.mainThread.async {
                        callback(false)
                    }
                    return
                }
                
                let identifier = oriTransaction.identifier
                let currency = oriTransaction.currency == "" ? "KRW" : oriTransaction.currency

                
                
                let searchInfo = try SearchInfo(id: String(describing: identifier),
                                                                 keyword: req.keyword,
                                                                 type: req.isExpense ? DwType.withdraw.str : DwType.deposit.str,
                                                                 at: req.date,
                                                                 method: method,
                                                                 amount: Double(req.amount),
                                                                 amountType: currency,
                                                                 lat: -1,
                                                                 long: -1,
                                                                 lCode: req.lCode,
                                                                 mCode: req.mCode)
                
                let searchReq = SearchCompanyRequest(transactions: [searchInfo])
                
                self.searchManager.searchCompany(reqData: searchReq, completion: { (err, response) in
                    
                    var companyId = 0
                    var companyName = ""
                    var companyAddress = ""
                    var code = Int(String(req.lCode) + String(req.mCode) + "10") ?? (req.isExpense ? 101010: 901010)
                    var searchKeyword = req.keyword
                    var classCode = ""
                    var isPopUpCompanyName = false
                    
                    if response.results.count > 0 { // 검색 응답값
                        let tranCompany: TranCompany = response.results[0]
                        companyId = tranCompany.company.id
                        companyName = tranCompany.company.name
                        companyAddress = tranCompany.company.address
                        code = tranCompany.category.code
                        searchKeyword = tranCompany.keyword.search
                        classCode = tranCompany.classCode
                        isPopUpCompanyName = tranCompany.isPopUpCompanyName
                    }
                    
                    let transaction = Transaction((
                        id : oriTransaction.id,
                        identifier : identifier,
                        cardId : req.cardId,
                        userCategoryId : req.cateConfigId,
                        companyId : companyId,
                        companyName : companyName,
                        
                        companyAddress : companyAddress,
                        code : code,
                        spentDate : req.date.toDate() ?? Date(),
                        finishDate : req.date.toDate() ?? Date(),
                        lat : -1.0,
                        lng : -1.0,
                        spentMoney : Double(req.amount),
                        oriSpentMoney : Double(req.amount),
                        installmentCnt : req.installmentCnt,
                        keyword : req.keyword,
                        searchKeyword : searchKeyword,
                        repeatType : oriTransaction.repeatType,
                        currency : oriTransaction.currency,
                        isDeleted : oriTransaction.isDeleted,
                        dwType : oriTransaction.dwType,
                        smsType : oriTransaction.smsType,
                        fullSms : oriTransaction.fullSms,
                        smsDate : oriTransaction.smsDate,
                        regId : oriTransaction.regId,
                        isOffset : oriTransaction.isOffset,
                        isCustom : oriTransaction.isCustom,
                        isUserUpdate : true,
                        isUpdateAll : req.isAll,
                        memo : req.memo,
                        classCode : classCode,
                        isSynced : false,
                        isPopUpCompanyName: isPopUpCompanyName
                    ))
                    
                    do {
                        try self.tranDao.edit([transaction])
                        
                        if req.isAll { // 일괄 적용
                            let transactions = try self.tranDao.find(by: transaction.keyword, transaction.dwType).map({ (tran) -> Transaction in
                                
                                var newTran = tran
                                //
                                newTran.userCategoryId = transaction.userCategoryId
                                newTran.companyId = transaction.companyId
                                newTran.companyName = transaction.companyName
                                newTran.companyAddress = transaction.companyAddress
                                newTran.code = transaction.code
                                newTran.isSynced = false
                                newTran.classCode = transaction.classCode
                                newTran.isPopUpCompanyName = transaction.isPopUpCompanyName

                                return newTran

                            })

                            try self.tranDao.edit(transactions)
                            
                        }
                        // TODO sync transaction 추가
                        self.appExecutor.mainThread.async {
                            callback(true)
                        }
                    } catch {
                        self.appExecutor.mainThread.async {
                            callback(false)
                        }
                    }
                })
                
            } catch {
                self.appExecutor.mainThread.async {
                    callback(false)
                }
            }
        }
    }
    
    func deleteTransaction(req: DeleteTransaction, callback: @escaping (Bool) -> ()) {
        self.appExecutor.diskIO.async {
            
            do {
        
                let transactions = try self.tranDao.find(by: req.ids).map({ (tran) -> Transaction in
                    
                    var newTran = tran
   
                    newTran.isDeleted = true
                    newTran.isSynced = false

                    return newTran
                    
                })
                
                try self.tranDao.edit(transactions)
                
                self.appExecutor.mainThread.async {
                     callback(true)
                }
               
            } catch {
                self.appExecutor.mainThread.async {
                    callback(false)
                }
            }
        }
    }

    func updateIsDeleted(callback: @escaping (Bool) -> ()) {
        self.appExecutor.diskIO.async {
         
            do {
                let transactions = try self.tranDao.findAll().map({ (tran) -> Transaction in
                    
                    var newTran = tran
                    
                    newTran.isDeleted = true
                    newTran.isSynced = false
                    
                    return newTran
                    
                })
                
                try self.tranDao.edit(transactions)
                
                self.appExecutor.mainThread.async {
                    callback(true)
                }
                
            } catch {
                self.appExecutor.mainThread.async {
                    callback(false)
                }
            }
        }
    }
    
    func initialize(callback: @escaping (Bool) -> ()) {
        self.appExecutor.diskIO.async {
            
            do {
                
                try self.tranDao.removeAll()
                
                try self.cardDao.removeAll()
                
                try self.userCateDao.removeAll()
                
//                try self.budgetDao.removeAll()
                
                if let cards = DataGenerator.card.datas {
                    try self.cardDao.save(cards as! [Card])
                }
            
                let lcodes = try self.categoryDao.findDistinctLocdes()
                try self.userCateDao.createData(lcodes: lcodes)
                
//
//                if let budgets = DataGenerator.budget().datas {
//                    try self.budgetDao.save(budgets as! [Budget])
//                }
                
                
                self.appExecutor.mainThread.async {
                    callback(true)
                }
                
            } catch {
                self.appExecutor.mainThread.async {
                    callback(false)
                }
            }
        }
    }
    
    //  보류
    func setBudget(_ req: BudgetRequest) {
        
    }
    
    //보류
    func getBudget(_ callback: String) {
        
    }
    
    // 보류
    func setBudgetReport(_ enabled: Bool) {
        
    }
    
    // 보류
    func isBudgetReportEnabled() -> Bool {
        return false
    }
    
    func insertCard(name: String, type: Int, callback: @escaping(_ res: Int)->()) {
        
        self.appExecutor.diskIO.async {
            
            do {
                
                let isExist = try self.cardDao.isExist(by: name, type, 0)
                if isExist {
                    callback(-1)
                } else {
                   
                    let card = Card((
                        id:0,
                        name: name,
                        type: type,
                        subType: 0,
                        changeName: name,
                        changeType: type,
                        changeSubType: 0,
                        billingDay: 1,
                        balance: 0.0,
                        memo: "",
                        isExcept: false,
                        isCustom: true,
                        isDeleted: false
                    ))
                    
                    let id = try self.cardDao.save(card)
                    callback(id)
                    
                }
            
                
            } catch {
                callback(-1)
            }
            
        }
    }

    
}


