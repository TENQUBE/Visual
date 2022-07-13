//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

public class TransactionModel: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var identifier: Int64 = 0
    @objc dynamic var cardId = 0
    @objc dynamic var userCategoryId = 0
    @objc dynamic var companyId = 0
    
    @objc dynamic var companyName = ""
    @objc dynamic var companyAddress = ""
    
    @objc dynamic var franchise = ""
    @objc dynamic var code = 0
    
    
    @objc dynamic var spentDate = Date()
    @objc dynamic var finishDate =  Date()
    
    
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    
    @objc dynamic var spentMoney: Double = 0
    @objc dynamic var oriSpentMoney: Double = 0
    
    @objc dynamic var installmentCnt = 0
    @objc dynamic var keyword = ""
    @objc dynamic var searchKeyword = ""
    @objc dynamic var repeatType = 0
    
    @objc dynamic var currency = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var dwType = 0
    
    @objc dynamic var smsType = 0
    @objc dynamic var fullSms: String?
    @objc dynamic var smsDate: Date?

    @objc dynamic var regId = 0
    
    @objc dynamic var isOffset = false
    @objc dynamic var isCustom = false
    @objc dynamic var isUserUpdate = false
    @objc dynamic var isUpdateAll = false
    
    @objc dynamic var memo = ""
    @objc dynamic var classCode = ""
    @objc dynamic var isSynced = false
   
    @objc dynamic var isPopUpCompanyName = false
    
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toTransaction() -> Transaction  {
     
        return Transaction((id: self.id,
                            identifier: self.identifier,
                            cardId: self.cardId,
                            userCategoryId: self.userCategoryId,
                            companyId: self.companyId,
                            companyName: self.companyName,
                            companyAddress: self.companyAddress,
                            code: self.code,
                            spentDate: self.spentDate,
                            finishDate: self.finishDate,
                            lat: self.lat,
                            lng: self.lng,
                            spentMoney: self.spentMoney,
                            oriSpentMoney: self.oriSpentMoney,
                            installmentCnt: self.installmentCnt,
                            keyword: self.keyword,
                            searchKeyword: self.searchKeyword,
                            repeatType: self.repeatType,
                            currency: self.currency,
                            isDeleted: self.isDeleted,
                            dwType: self.dwType,
                            smsType: self.smsType,
                            fullSms: self.fullSms,
                            smsDate: self.smsDate,
                            
                            regId: self.regId,
                            isOffset: self.isOffset,
                            isCustom: self.isCustom,
                            isUserUpdate: self.isUserUpdate,
                            isUpdateAll: self.isUpdateAll,
                            memo: self.memo,
                            classCode: self.classCode,
                            isSynced: self.isSynced,
                            isPopUpCompanyName: self.isPopUpCompanyName
                            
            
        ))
        
        
    }
}
