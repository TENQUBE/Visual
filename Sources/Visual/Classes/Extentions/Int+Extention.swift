//
//  String+Extention.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

extension Int {

    func getUserCateCode() -> Int {
        let code = String(self)
        
        if code.count >= 2 {
            let lcode = code[0..<2]
            return Int(lcode + "1010")!
        }
        
        return self
    }
    
    func toNumberformat() -> String {
        return String(format: "%.d",locale: Locale.current, self)
    }
    
    
    func toMonthStr() -> String {
        return "\(self)월"
    }
    
    func toStr() -> String {
        return "\(self)"
    }
//    func
   
    
}


