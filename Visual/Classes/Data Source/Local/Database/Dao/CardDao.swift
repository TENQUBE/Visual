//
//  CardDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.

import RealmSwift

public class CardDao: BaseDao, CardDataSource {
  
    
    func find(by id: Int) throws -> Card? {
        let whereCond = QueryBuilder().id(id: id).build()
        
        guard let result = try realmManager.getObjects(type: CardModel.self).filter(whereCond).first else {
            return nil
        }
        
        return (result as! CardModel).toCard()
    }
    
    func find(by name: String, _ type: Int, _ subType: Int, balance: Double) throws -> Card {
        
        let whereCond = QueryBuilder()
            .cardName(name: name)
            .and()
            .cardType(type: type)
            .and()
            .cardSubType(subType: subType)
            .build()
        
        let result = try realmManager.getObjects(type: CardModel.self).filter(whereCond).first
        
        if result == nil {
            
            let model = CardModel()
            model.id = try self.realmManager.incrementID(type: CardModel.self)
            model.name = name
            model.type = type
            model.subType = subType
            model.changeName = name
            model.changeType = type
            model.changeSubType = subType
            model.billingDay = 1
            model.balance = balance
            model.memo = ""
            model.isExcept = false
            model.isCustom = false
            model.isDeleted = false
            
            try self.realmManager.saveObjects(objs: model)
            
            return model.toCard()
         
        
        }
        
        return (result as! CardModel).toCard()
        
    }
    
    func find(by isExcept: Bool) throws -> [Card] {
        
        let whereCond = QueryBuilder().isExcept(isExcept: isExcept).build()
        
        let results = try realmManager.getObjects(type: CardModel.self).filter(whereCond)
        
        return results.map {
            ($0 as! CardModel).toCard()
        }
    }
    
    func find(by cardIds: [Int]) throws -> [Card] {
        let whereCond = QueryBuilder().ids(ids: cardIds).build()
        
        let results = try realmManager.getObjects(type: CardModel.self).filter(whereCond)
        
        return results.map {
            ($0 as! CardModel).toCard()
        }
    }
   
    public func findAll() throws -> [Card] {
   
        let results = try realmManager.getObjects(type: CardModel.self)
    
        return results.map {
                ($0 as! CardModel).toCard()
        }
  
    }
    
    public func save(_ elements: [Card]) throws {
        
        for element in elements {
            let model = CardModel()
            model.id = try self.realmManager.incrementID(type: CardModel.self)
            model.name = element.name
            model.type = element.type
            
            model.subType = element.subType
            model.changeName = element.changeName
            model.changeType = element.changeType
            model.changeSubType = element.changeSubType
            model.billingDay = element.billingDay
            model.balance = element.balance
            model.memo = element.memo
            model.isExcept = element.isExcept
            model.isCustom = element.isCustom
            model.isDeleted = element.isDeleted
            
            try self.realmManager.saveObjects(objs: model)
        }
        
    }
    
    public func removeAll() throws {
        
        let objects = try realmManager.getObjects(type: CardModel.self)
        try realmManager.deleteObject(objs: objects)
        
    }
}
