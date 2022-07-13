//
//  DateUtil.swift
//  Visual
//
//  Created by tenqube on 18/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

enum DateType {
    case day(Int)
    case week(Int)
    case month(Int)
    case lastThreeMonth
    case year
}

public typealias DateRange = (from:Date, to:Date)

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func getIntervalDay(since startDate: Date) -> Int {
        let interval = self.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
    
        return days
    }
    
    func getValue(componet: Calendar.Component) -> Int {
        return Calendar.current.component(componet, from: self)
    }
    
    func toStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return format.string(from: self)
    }
    
    func toYMStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM"
        
        return format.string(from: self)
    }
    
    func toYMDStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyy년MM월dd일"
        
        return format.string(from: self)
    }
    
    func toMDStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM월dd일"
        
        return format.string(from: self)
    }
    
    func toDayStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        
        return format.string(from: self)
    }
    
    static func from(year: Int, month: Int) -> Date? {
        
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.nanosecond = 0

        
        return calendar.date(from: dateComponents) ?? nil
    
    }
    
    func getMonthStr(type: DateType) -> String {
        
        var monthStr = [String]()
        
        var month = getValue(componet: .month)
        var n = 1
        switch type {
        case .lastThreeMonth:
            n = 3
        default:
            n = 1
        }
        
        for _ in 0..<n {
            monthStr.append("\(month) 월")
            month = month + 1
            month = month == 13 ? 1 : month
        }
        
        return monthStr.joined(separator: ",")
    }
 
    
    func getDateRanges(type: DateType) -> DateRange {
      
        // 이번달 1일 시작일
        let date = self.startOfMonth()
        
        var startDate = date
        var endDate = date
        
        switch type {
        case .day(let before):
            
            let today = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) ?? Date()
            let yesterDay = today.addDay(day: -1 * before) ?? Date()
            
            startDate = yesterDay
            endDate = today

        case .week(let before):
            let today = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) ?? Date()

            let dayOfWeek = Calendar.current.component(.weekday, from: today)
            
            var startDateNum = 0
            
            if dayOfWeek == 1 { //일요일
                startDateNum = -7 * before - 6
                
            } else {
                startDateNum = -7 * before - (dayOfWeek - 2)
            }
            
            startDate =  Calendar.current.date(byAdding: DateComponents(day: startDateNum), to: today) ?? Date()
        
            endDate =  Calendar.current.date(byAdding: DateComponents(day: startDateNum + 7), to: today) ?? Date()

            
            break
        case .month(let before):
            startDate = date.getNthMonth(nth: -1 * before)!
            endDate = date.getNthMonth(nth: (-1 * before) + 1 )!
            break
        case .lastThreeMonth:
            startDate = date.getNthMonth(nth: -1 * 3)!
            break
            
        case .year:
            startDate =  Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
            break

        }
        
        return (startDate, endDate)
        
        
    }
    
    func getSamePeriodEndDate(before: Int) -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self))!

    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    

    func getNthMonth(nth: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1 * nth, to: self)
    }
    
    func addDay(day: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: day, to: self)
    }
    
}
