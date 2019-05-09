//
//  TransactionDao.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

public class TransactionDao: BaseDao, TransactionDataSource {
  
    public func findAll() throws -> [Transaction] {
        let elements = try realmManager.getObjects(type: TransactionModel.self)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
    }
    
    func find(by req: WebTransactionRequest) throws -> [Transaction] {
        let whereCond = QueryBuilder()
            .date(year: req.year, month: req.month, before: req.before)
            .and()
            .isDeleted(isDeleted: false)
            .build()
        
    
        
        let elements = try realmManager.getObjects(type: TransactionModel.self).filter(whereCond)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
        
    }
    
    func find(by isSynced: Bool) throws -> [Transaction] {
        let whereCond = QueryBuilder()
            .isSynced(isSynced: false)
            .build()
        

        let elements = try realmManager.getObjects(type: TransactionModel.self).filter(whereCond)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
    }
    
    
    func find(by id: Int) throws -> Transaction? {
        let wherCond = QueryBuilder().id(id: id).build()
        
        guard let element = try realmManager.getObjects(type: TransactionModel.self).filter(wherCond).first else {
            return nil
        }
        
        return (element as! TransactionModel).toTransaction()
        
    }
    
    func find(by ids: [Int]) throws -> [Transaction] {
      
        let wherCond = QueryBuilder().ids(ids: ids).build()
         
        let elements = try realmManager.getObjects(type: TransactionModel.self).filter(wherCond)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
    }
    
    func find(by identifiers: [Int64]) throws -> [Transaction] {
        
        let wherCond = QueryBuilder().identifiers(identifiers: identifiers).build()
        
        let elements = try realmManager.getObjects(type: TransactionModel.self).filter(wherCond)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
    }
    
    func find(by keyword: String, _ dwType: Int) throws -> [Transaction] {
        let wherCond = QueryBuilder()
            .keyword(keyword: keyword)
            .and()
            .dwType(dwType: dwType)
            .build()
        
        let elements = try realmManager.getObjects(type: TransactionModel.self).filter(wherCond)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
    }
    
    func find(by keywords: [String]) throws -> [Transaction] {
        let wherCond = QueryBuilder()
            .keywords(keywords: keywords)
            .and()
            .isPopUpCompanyName(flag: true)
            .build()
        
        let elements = try realmManager.getObjects(type: TransactionModel.self).filter(wherCond)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
    }
    
    func findForApplyAll(by keywords: [String]) throws -> [Transaction] {
        let wherCond = QueryBuilder()
            .keywords(keywords: keywords)
            .and()
            .isUpdateAll(flag: true)
            .build()
        
        let elements = try realmManager.getObjects(type: TransactionModel.self).filter(wherCond)
        
        return elements.map {
            ($0 as! TransactionModel).toTransaction()
        }
    }
    
    public func save(_ elements: [Transaction]) throws {
        
        for element in elements {
            let model = try element.toRealmObj(realmManager: self.realmManager)
            
            try self.realmManager.saveObjects(objs: model)
        }
        
    }
    
    func save(_ element: Transaction) throws -> Int {
        let model = try element.toRealmObj(realmManager: self.realmManager)
        try self.realmManager.saveObjects(objs: model)
        
        return model.id
    }
    
    func edit(_ elements: [Transaction]) throws {
        for element in elements {
            let model = try element.toRealmObj(realmManager: nil)
            try self.realmManager.editObjects(objs: model)
        }
    }
    
    func remove(by ids: [Int]) throws {
        let whereCond = QueryBuilder().ids(ids: ids).build()
        
        let objects = try self.realmManager.getObjects(type: TransactionModel.self).filter(whereCond)
        
        try self.realmManager.deleteObject(objs: objects)
    }
    
    public func removeAll() throws {
        
        let objects = try realmManager.getObjects(type: TransactionModel.self)
        try realmManager.deleteObject(objs: objects)
        
    }
}
