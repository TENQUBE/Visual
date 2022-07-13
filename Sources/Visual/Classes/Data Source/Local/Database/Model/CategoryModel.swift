//
//  Category.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class CategoryModel: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var code = 0
    @objc dynamic var large = ""
    @objc dynamic var medium = ""
    @objc dynamic var small = ""

    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toCategory() -> Category  {
        let category = Category((id: self.id, code: self.code, large: self.large,
                         medium: self.medium, small: self.small))
        return category
        
    }
    
}
