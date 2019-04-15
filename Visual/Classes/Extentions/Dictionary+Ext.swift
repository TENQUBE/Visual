//
//  Dictionary+Ext.swift
//  Visual
//
//  Created by tenqube on 12/03/2019.
//

import Foundation
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
