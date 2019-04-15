//
//  AdvertisementDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class AdvertisementDao: BaseDao, AdvertisementDataSource {

    public func findAll() throws -> [Advertisement] {
        guard let elements = try realmManager.getObjects(type: AdvertisementModel.self) else {
            return []
        }
        
        return elements.map({
            ($0 as! AdvertisementModel).toAdvertisment()
        })
    }
    
    public func save(_ elements: [Advertisement]) throws {
        
        for element in elements {
            let model = AdvertisementModel()
            model.id = element.id
            model.title = element.title
            model.label = element.label
            model.content = element.content
            model.linkTo = element.linkTo
            
            model.linkToType = element.linkToType
            model.linkToStr = element.linkToStr
            model.image = element.image
            model.iconImage = element.iconImage
            model.priority = element.priority
            model.query = element.query
            
            try self.realmManager.saveObjects(objs: model)
        }
        
    }
    
    public func edit(_ elements: [Advertisement]) throws {
        
        for element in elements {
            let model = AdvertisementModel()
            model.id = element.id
            model.title = element.title
            model.label = element.label
            model.content = element.content
            model.linkTo = element.linkTo
            
            model.linkToType = element.linkToType
            model.linkToStr = element.linkToStr
            model.image = element.image
            model.iconImage = element.iconImage
            model.priority = element.priority
            model.query = element.query
            
            try self.realmManager.editObjects(objs: model)
        }
        
    }
    
    
}
