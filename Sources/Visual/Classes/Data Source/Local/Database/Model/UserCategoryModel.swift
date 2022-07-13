//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

public class UserCategoryModel: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var code = 0
    @objc dynamic var isExcept = false
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toUserCategory() -> UserCategory  {
        return UserCategory((id: self.id, code: self.code, isExcept: self.isExcept))
        
    }
}
