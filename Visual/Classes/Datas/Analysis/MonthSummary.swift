//
//  MonthSummary.swift
//  Visual
//
//  Created by tenqube on 12/03/2019.
//

import Foundation
struct MonthSummary {
    
    let transactions: [JoinedTransaction]
    let monthStr: String
    let sum: Double
    let tranIds: [Int]
    let sumByCard: [String: AnalysisValue]
    let sumByCategory: [String: AnalysisValue]
    
    var avg: Double = 0

    init(monthStr: String, sum: Double, tranIds: [Int], sumByCard:[String: AnalysisValue], sumByCategory: [String: AnalysisValue], transactions: [JoinedTransaction]) {
        self.monthStr = monthStr
        self.sum = sum
        self.tranIds = tranIds
        self.sumByCard = sumByCard
        self.sumByCategory = sumByCategory
        self.transactions = transactions
    }
    
    func getMonthStr() -> String {
        return "\(monthStr)월"
    }
    
    func getCardList() -> [AnalysisValue] {
        return sumByCard.flatMap {
            [$0.value]
            }.sorted(by: {
                
                return $0.amount > $1.amount
                
            })
    }
    
    func getCategoryList() -> [AnalysisValue] {
        return sumByCategory.flatMap {
            [$0.value]
            }.sorted(by: {
                
                return $0.amount > $1.amount
                
            })
    }

        
}
