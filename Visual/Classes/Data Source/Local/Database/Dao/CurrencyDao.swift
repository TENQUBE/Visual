//
//  CardDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

public class CurrencyDao: BaseDao, CurrencyDataSource {
 

    public func find(by from: String, _ to: String) throws -> Currency? {
//        let whereCond = NSPredicate(format: "from = %@ AND to = %@", [from, to])
        let whereCond = QueryBuilder().from(from: from).and().to(to: to).build()
        
        guard let obj = try realmManager.getObjects(type: CurrencyModel.self)?.filter(whereCond).first,
            let currencyModel = obj as? CurrencyModel else {
                return nil
        }
        
        return currencyModel.toCurrency()

    }
    
    public func find(by fromTo: [(String, String)]) throws -> [Currency] {
        
        let whereCond = QueryBuilder().fromTo(fromTo: fromTo).build()
   
        guard let elements = try realmManager.getObjects(type: CurrencyModel.self)?.filter(whereCond) else {
            return []
        }
        
        return elements.map({
            ($0 as! CurrencyModel).toCurrency()
        })
        
    }
    
    public func save(_ elements: [Currency]) throws {
        
        for element in elements {
            let model = CurrencyModel()
            model.id = element.id
            model.from = element.from
            model.to = element.to
            model.rate = element.rate
            model.createdAt = element.createdAt
        
            try self.realmManager.saveObjects(objs: model)
        }
        
    }
    
    public func removeAll() throws {
        if let objects = try realmManager.getObjects(type: CurrencyModel.self) {
            try realmManager.deleteObject(objs: objects)
        }
    }
   
}
