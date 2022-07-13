//
//  AlcoholSummary.swift
//  Visual
//
//  Created by tenqube on 18/03/2019.
//

import Foundation

public typealias Beer = ((month:Int, cnt:Int, sum:Double, tranIds:[Int]))

struct AlcoholSummary {
    
    // 지난 3개월 술집 지출
    
    // 지난달 술집 건수
    
    // 어제 술값
    
    
    let months : [Beer] // 월, 건, 합, tranIds
    
    let alcoholType: String
    
    let alcoholTypeImg: String
    
    let yesterdaySum: Double
    
    let lastThreeMonthSum: Double
    
    
    
}
