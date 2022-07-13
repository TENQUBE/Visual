//
//  Transaction.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

public class ReportNotificationModel: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var title: String = ""
    
    @objc dynamic var content: String = ""
    @objc dynamic var ticker: String = ""
    @objc dynamic var alarmType: Int = 0

    @objc dynamic var dayOfWeek: Int = 0
    @objc dynamic var hour: Int = 0
    @objc dynamic var day: Int = 0

    @objc dynamic var enabled: Bool = true

    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    func toNotification() -> ReportNotification  {
        return ReportNotification((id: self.id, name: self.name, title: self.title, content: self.content, ticker: self.ticker, alarmType: self.alarmType, dayOfWeek: self.dayOfWeek, hour: self.hour, day: self.day, enabled: self.enabled))
        
    }
}
