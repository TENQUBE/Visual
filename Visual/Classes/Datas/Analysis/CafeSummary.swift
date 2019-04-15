//
//  CafeSummary.swift
//  Visual
//
//  Created by tenqube on 18/03/2019.
//

import Foundation

typealias Coffee = (month: Int, cnt: Int, sum: Double, tranIds: [Int])

struct CafeSummary {
    
    // 월별
    let months:[(Coffee)]
    
    // 커피타입, 커피 타입 예시
    let coffeeType: String
    let coffeeTypeEx: String
    
    // 일주일에 카페 몇회 지난 3개월
    let onceAweek: Double

    let cntOfThreeMonth: Int
    // 지난 3개월 커피지출 합
    let sumOfThreeMonth: Double
    
    // 지난 3개월 모닝커피 지출 합
    let sumOfMorning: Morning
    
    // 이번달 커피 맥스 날짜
    let maxDate: String?
    
}
