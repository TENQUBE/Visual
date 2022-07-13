//
//  String+Extention.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

extension Double {

    func toLv0Format() -> String {
        if self < 1000 {
            return String(format: "%.f원",locale: Locale.current, self)
        } else {
            return String(format: "%.1f만원",locale: Locale.current, self/10000)
        }
    }
    
    func toPercent() -> String {
       return String(format: "%.1f",locale: Locale.current, self) + "%"
    }
    
    func toNumberformat() -> String {
        return String(format: "%.f",locale: Locale.current, self)
    }
    
    func toFirstDotFormat() -> String {
        return String(format: "%.1f",locale: Locale.current, self)
    }
    
//    func
    
    
    
}


