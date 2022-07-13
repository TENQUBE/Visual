//
//  String+Extention.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

extension String {
    
    func toMonth() -> Int {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM"
        let date = format.date(from: self)
        return date?.getValue(componet: .month) ?? 0
    }

    func toDate() -> Date? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.locale = Locale.current
        
        return format.date(from: self)
        
    }
    
    func toYMD() -> Date? {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        format.locale = Locale.current
        
        return format.date(from: self)
        
    }
    
    func toTime() -> Date? {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        format.locale = Locale.current
        
        return format.date(from: self)
        
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
  
    func parseTSV() -> [[String]] {
        var result: [[String]] = []
        let rows = self.components(separatedBy: Constants.Separator.newLine.rawValue)
        var i = 0
        for row in rows {
            if i == 0 {
                 i = i + 1
                continue
            }
            let columns = row.components(separatedBy: "\t")
          
            if columns.count > 1 {
                result.append(columns)
                
            }
        }
      
        return result
    }
    
    // 2) ascii array to map our string
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
    
    // this is our hashCode function, which produces equal output to the Java or Android hash function
    func hashCode() -> Int32 {
        var h : Int32 = 0
        for i in self.asciiArray {
            h = 31 &* h &+ Int32(i) // Be aware of overflow operators,
        }
        return h
    }
    
    func replaceSlash() -> String {
        return self.replacingOccurrences(of: "\\n", with: Constants.Separator.newLine.rawValue, options: .literal, range: nil)
    }
    
    
}


