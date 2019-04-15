//
//  Card.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class CardModel: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var type = 0
    @objc dynamic var subType = 0
    @objc dynamic var changeName = ""
    @objc dynamic var changeType = 0
    @objc dynamic var changeSubType = 0
    @objc dynamic var billingDay = 0
    @objc dynamic var balance = 0.0
    @objc dynamic var memo = ""
    @objc dynamic var isExcept = false
    @objc dynamic var isCustom = false
    @objc dynamic var isDeleted = false
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toCard() -> Card  {
        let card = Card((id: self.id, name: self.name, type: self.type,
                                subType: self.subType, changeName: self.changeName, changeType: self.changeType,
                                changeSubType: self.changeSubType, billingDay: self.billingDay, balance: self.balance,
                                memo: self.memo, isExcept: self.isExcept, isCustom: self.isCustom, isDeleted: self.isDeleted))
        
        return card
        
    }
}
