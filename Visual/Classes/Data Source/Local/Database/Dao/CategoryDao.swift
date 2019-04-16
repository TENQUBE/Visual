//
//  CardDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class CategoryDao : BaseDao, CategoryDataSource {
    
    func find(by code: Int) throws -> Category? {
        let whereCond = QueryBuilder().code(code: code).build()
        
        guard let obj = try self.realmManager.getObjects(type: CategoryModel.self)?.filter(whereCond).first else {
            return nil
        }
        
        return (obj as! CategoryModel).toCategory()
    }
    
   
    func find(by codes: [Int]) throws -> [Category] {
        let whereCond = QueryBuilder().codes(codes: codes).build()
     
        guard let results = try self.realmManager.getObjects(type: CategoryModel.self)?.filter(whereCond) else {
            return []
        }
        
        return results.map {
            ($0 as! CategoryModel).toCategory()
        }
    }

    func findDistinctLocdes() throws  -> [Int] {
        
        guard let values = try self.realmManager.getObjects(type: CategoryModel.self) else {
            return []
        }
        
        let results = values.map({
            Int(String(($0 as! CategoryModel).code)[0..<2] + "1010")
        })
        
        return Array(Set(results)) as! [Int]
    }
    
    func createData() throws {
        let categories = DataGenerator.category.datas
        guard let values = categories else {
            return
        }
        
        for category in values {
            if let categoryModel = category as? CategoryModel {
                try self.realmManager.saveObjects(objs: categoryModel)
            }
        }
    }

    func findAll() throws -> [Category]  {
        
        guard let values = try self.realmManager.getObjects(type: CategoryModel.self) else {
            return []
        }
   
        return values.map({
            ($0 as! CategoryModel).toCategory()
        }).filter{$0.code != 111010}
        
    }
    
    func save(_ elements: [Category]) throws {
        for element in elements {
            let model = CategoryModel()
            model.id = element.id
            model.code = element.code
            model.large = element.large
            model.medium = element.medium
            model.small = element.small
   
            try self.realmManager.saveObjects(objs: model)
        }
    }
    
    func edit(_ elements: [Category]) throws {
        for element in elements {
            let model = CategoryModel()
            model.id = element.id
            model.code = element.code
            model.large = element.large
            model.medium = element.medium
            model.small = element.small
            
            try self.realmManager.editObjects(objs: model)
        }
    }
    
    func remove(_ elements: [Category]) throws {
        for element in elements {
            let model = CategoryModel()
            model.id = element.id
            model.code = element.code
            model.large = element.large
            model.medium = element.medium
            model.small = element.small
            
            try self.realmManager.deleteObject(objs: model)
        }
    }
    
    public func removeAll() throws {
        if let objects = try realmManager.getObjects(type: CategoryModel.self) {
            try realmManager.deleteObject(objs: objects)
        }
    }
    
   
}
