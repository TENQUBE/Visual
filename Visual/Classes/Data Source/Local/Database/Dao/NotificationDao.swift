//
//  AdvertisementDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class NotificationDao: BaseDao, NotificationDataSource {
  
    public func findAll() throws -> [ReportNotification] {
        let elements = try realmManager.getObjects(type: ReportNotificationModel.self)
        
        return elements.map({
            ($0 as! ReportNotificationModel).toNotification()
        })
    }
    
    func find(by name: String) throws -> [ReportNotification] {
        let whereCond = QueryBuilder().nameC(name: name).build()
        let elements = try realmManager.getObjects(type: ReportNotificationModel.self).filter(whereCond)
        
        return elements.map({
            ($0 as! ReportNotificationModel).toNotification()
        })
    }
    
    public func save(_ elements: [ReportNotification]) throws {
        
        for element in elements {
            let model = ReportNotificationModel()
            model.id = element.id
            model.name = element.name
            model.title = element.title
            model.content = element.content
            model.ticker = element.ticker
            model.alarmType = element.alarmType
            model.dayOfWeek = element.dayOfWeek
            model.hour = element.hour
            model.day = element.day
            model.enabled = element.enabled
            
            try self.realmManager.saveObjects(objs: model)
        }
    }
    
    func edit(elements: [ReportNotification]) throws {
        
        for element in elements {
            let model = ReportNotificationModel()
            model.id = element.id
            model.name = element.name
            model.title = element.title
            model.content = element.content
            model.ticker = element.ticker
            model.alarmType = element.alarmType
            model.dayOfWeek = element.dayOfWeek
            model.hour = element.hour
            model.day = element.day
            model.enabled = element.enabled
            
            try self.realmManager.editObjects(objs: model)
        }
    }
}
