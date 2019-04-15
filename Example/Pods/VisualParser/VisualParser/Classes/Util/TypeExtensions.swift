//
//  TypeExtensions.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

private let krLocale = Locale(identifier: "ko_KR")

extension Double {
    var krCurrency: String? {
        let num = self as NSNumber
        let formatter = NumberFormatter()
        formatter.locale = krLocale
        formatter.numberStyle = .currency
        return formatter.string(from: num)
    }
}

extension String {
    var isNumeric: Bool {
        guard !self.isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }

    func toDate() -> Date? {
        let format = "yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        return dateFormatter.date(from: self)
    }

    var isDateFormat: Bool {
        let date = self.toDate()
        if  date != nil {
            return true
        } else {
            return false
        }
    }

    func isOver(than d: String) -> Bool {
        guard let currentDate = self.toDate(), let compareDate = d.toDate() else {
            return false
        }

        return currentDate > compareDate
    }

    func add(year: Int) -> String {
        guard let currentDate = self.toDate() else {
            return self
        }

        guard let subDate = currentDate.add(year: year) else {
            return self
        }

        return subDate.toString()
    }
}

extension NSDate {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self as Date)
    }
}

extension Date {
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self)
    }

    var year: String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self)
    }

    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self)
    }

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self)
    }

    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self)
    }

    var min: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self)
    }

    var sec: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        dateFormatter.locale = krLocale
        return dateFormatter.string(from: self)
    }

    func add(year: Int) -> Date? {
        if let result = Calendar.current.date(byAdding: .year, value: year, to: self) {
            return result
        }

        return nil
    }

    func add(month: Int) -> Date? {
        if let result = Calendar.current.date(byAdding: .month, value: month, to: self) {
            return result
        }

        return nil
    }

    func add(day: Int) -> Date? {
        if let result = Calendar.current.date(byAdding: .day, value: day, to: self) {
            return result
        }

        return nil
    }

    func add(hour: Int) -> Date? {
        if let result = Calendar.current.date(byAdding: .hour, value: hour, to: self) {
            return result
        }

        return nil
    }

    func add(min: Int) -> Date? {
        if let result = Calendar.current.date(byAdding: .minute, value: min, to: self) {
            return result
        }

        return nil
    }
}
