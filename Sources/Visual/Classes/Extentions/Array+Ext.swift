//
//  DateUtil.swift
//  Visual
//
//  Created by tenqube on 18/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}
