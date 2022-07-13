//
//  CategorySummary.swift
//  Visual
//
//  Created by tenqube on 17/03/2019.
//

import Foundation
struct CategorySummary {
    // 카테고리명
    let name: String
    
    // 월
    let month: Int
    
    //합
    let sum: Double
    
    // 최대 지출처
    var maxTransaction: JoinedTransaction?
    
    // 중분류별 합
    let sumByMedium: [AnalysisValue]
    
    let tranIds: [Int]

    
}
