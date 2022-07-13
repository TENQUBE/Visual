//
//  MartSummary.swift
//  Visual
//
//  Created by tenqube on 18/03/2019.
//

import Foundation
public typealias TransportValue  = ((month:Int, sum:Double, tranIds:[Int]))

struct TransportSummary {
    
    let sumOfMorning: Morning
   
    let taxiMonths: [TransportValue]
    
    let sumOfThreeMonth: Double
    
}
