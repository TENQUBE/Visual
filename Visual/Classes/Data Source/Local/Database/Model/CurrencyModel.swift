//
//  Currency.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class CurrencyModel: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var from = ""
    @objc dynamic var to = ""
    @objc dynamic var rate: Double = 0
    @objc dynamic var createdAt = ""
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toCurrency() -> Currency  {
        let currency = Currency((id: self.id, from: self.from, to: self.to,
                                 rate: self.rate, createdAt: self.createdAt))
        
 
        return currency
        
    }
}
