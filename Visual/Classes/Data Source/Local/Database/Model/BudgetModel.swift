//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

public class BudgetModel: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var budget: Int = 0
    @objc dynamic var categoryCode: Int = 0
    
    @objc dynamic var date: Date = Date()
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toBudget() -> Budget  {
        return Budget((id: self.id, budget: self.budget, categoryCode: self.categoryCode, date: self.date))
        
    }
}
