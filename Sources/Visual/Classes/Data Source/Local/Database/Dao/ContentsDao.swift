//
//  AdvertisementDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class ContentDao: BaseDao, ContentDataSource {
    
    
    func findAll() throws -> [Content] {
        
        let elements = try realmManager.getObjects(type: ContentModel.self)
        
        return elements.map({
            ($0 as! ContentModel).toContent()
        })
    }
    
    
    func save(_ elements: [Content]) throws {
        for element in elements {
            let model = ContentModel()
            model.id = element.id
            model.priority = element.priority
            model.categoryPriority = element.categoryPriority
            model.numOfOccurrence = element.numOfOccurrence
            model.lCode = element.lCode
            model.rawKeys = element.rawKeys
            model.linkTo = element.linkTo
            model.label = element.label
            model.largeContent = element.largeContent.replaceSlash()
            model.largeKeys = element.largeKeys
            model.mediumContent = element.mediumContent.replaceSlash()
            model.mediumKeys = element.mediumKeys
            model.image = element.image
            

            try self.realmManager.saveObjects(objs: model)
        }
    }
    
    func edit(_ elements: [Content]) throws {
        for element in elements {
            let model = ContentModel()
            model.id = element.id
            model.priority = element.priority
            model.categoryPriority = element.categoryPriority
            model.numOfOccurrence = element.numOfOccurrence
            model.lCode = element.lCode
            model.rawKeys = element.rawKeys
            model.linkTo = element.linkTo
            model.label = element.label
            model.largeContent = element.largeContent
            model.largeKeys = element.largeKeys
            model.mediumContent = element.mediumContent
            model.mediumKeys = element.mediumKeys
            model.image = element.image
            
            
            try self.realmManager.editObjects(objs: model)
        }
    }
    
    public func removeAll() throws {
        let objects = try realmManager.getObjects(type: ContentModel.self)
        try realmManager.deleteObject(objs: objects)
        
    }

}
