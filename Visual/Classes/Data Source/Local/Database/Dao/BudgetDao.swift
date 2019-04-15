//
//  AdvertisementDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class BudgetDao: BaseDao, BudgetDataSource {

    public func findAll() throws -> [Budget] {
        guard let elements = try realmManager.getObjects(type: BudgetModel.self) else {
            return []
        }
        
        return elements.map({
            ($0 as! BudgetModel).toBudget()
        })
    }
    
    public func save(_ elements: [Budget]) throws {
        
        for element in elements {
            let model = BudgetModel()
            model.id = element.id
            model.budget = element.budget
            model.date = element.date
            model.categoryCode = element.categoryCode
        
            try self.realmManager.saveObjects(objs: model)
        }
        
    }
    
    public func removeAll() throws {
        if let objects = try realmManager.getObjects(type: BudgetModel.self) {
            try realmManager.deleteObject(objs: objects)
        }
    }
}
