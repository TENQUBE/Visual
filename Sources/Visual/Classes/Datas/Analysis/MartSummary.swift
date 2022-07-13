//
//  MartSummary.swift
//  Visual
//
//  Created by tenqube on 18/03/2019.
//

import Foundation
public typealias MartValue  = ((month:Int, sum:Double, tranIds:[Int]))

struct MartSummary {
    
    let martMonths: [MartValue]
    
    let convenienceMonths: [MartValue]
    
}
