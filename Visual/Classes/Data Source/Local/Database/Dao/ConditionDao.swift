//
//  AdvertisementDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class ConditionDao: BaseDao, ConditionDataSource {


    func findAll() throws -> [Condition] {
        
        guard let elements = try realmManager.getObjects(type: ConditionModel.self) else {
            return []
        }
        
        return elements.map({
            ($0 as! ConditionModel).toCondition()
        })
    }

    func save(_ elements: [Condition]) throws {
        for element in elements {
            let model = ConditionModel()
            model.id = element.id
            model.cId = element.cId
            model.standard = element.standard
            model.funcType = element.funcType
            model.funcKeys = element.funcKeys
            
            try self.realmManager.saveObjects(objs: model)
        }
    }
    
    func edit(_ elements: [Condition]) throws {
        for element in elements {
            let model = ConditionModel()
            model.id = element.id
            model.cId = element.cId
            model.standard = element.standard
            model.funcType = element.funcType
            model.funcKeys = element.funcKeys
            
            try self.realmManager.editObjects(objs: model)
        }
    }
    
    public func removeAll() throws {
        if let objects = try realmManager.getObjects(type: ConditionModel.self) {
            try realmManager.deleteObject(objs: objects)
        }
    }
    
}
