//
//  CardDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

public class UserCategoryDao: BaseDao, UserCategoryDataSource {
    
    func createData(lcodes: [Int]) throws {
        var pk = 1
        
        for lcode in lcodes {
            
            let userCategoryModel = UserCategoryModel()
            userCategoryModel.id = pk
            userCategoryModel.code = lcode
            userCategoryModel.isExcept = Constants.ExceptCode.Deposit == lcode || Constants.ExceptCode.Withdraw == lcode
            try realmManager.saveObjects(objs: userCategoryModel)
            pk = pk + 1
            
        }
    }
    
    public func findAll() throws -> [UserCategory] {
        
        let elements = try realmManager.getObjects(type: UserCategoryModel.self)
    
        return elements.map({
    
            ($0 as! UserCategoryModel).toUserCategory()
            
        })
    }
    
    func find(by ids: [Int]) throws -> [UserCategory] {
        let whereCond = QueryBuilder().ids(ids: ids).build()
        
        let results = try realmManager.getObjects(type: UserCategoryModel.self).filter(whereCond)
        
        return results.map {
            ($0 as! UserCategoryModel).toUserCategory()
        }
    }
    
    func find(by id: Int) throws -> [UserCategory] {
        let whereCond = QueryBuilder().id(id: id).build()
        
        let results = try realmManager.getObjects(type: UserCategoryModel.self).filter(whereCond)
        
        return results.map {
            ($0 as! UserCategoryModel).toUserCategory()
        }
    }
    
    func find(by isExcept: Bool) throws -> [UserCategory] {
        
        let whereCond = QueryBuilder().isExcept(isExcept: isExcept).build()
        
        let results = try realmManager.getObjects(type: UserCategoryModel.self).filter(whereCond)
        
        return results.map {
            ($0 as! UserCategoryModel).toUserCategory()
        }
    }
    
    func findByCode(code: Int) throws -> UserCategory? {
        
        let whereCond = QueryBuilder().code(code: code).build()
        
        guard let obj = try realmManager.getObjects(type: UserCategoryModel.self).filter(whereCond).first else {
            return nil
        }
        
        return (obj as! UserCategoryModel).toUserCategory()
        
    }

    func save(_ elements: [UserCategory]) throws {
        for element in elements {
            let model = UserCategoryModel()
            model.id = element.id
            model.code = element.code
            model.isExcept = element.isExcept
           
            try self.realmManager.saveObjects(objs: model)
        }
    }
    
    public func removeAll() throws {
        let objects = try realmManager.getObjects(type: UserCategoryModel.self)
        try realmManager.deleteObject(objs: objects)
        
    }
 
}
