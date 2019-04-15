//
//  File.swift
//  Visual
//
//  Created by tenqube on 14/03/2019.
//

import Foundation

typealias LastAction = (cnt: Int, keyword: String, date: String, day: Int, tranIds: [Int])

typealias Morning = (sum: Double, tranIds: [Int])

class Calculator {
    
    let threeMonthDays: Int
    let today: Int
    let threeMonthDates: DateRange
    
    
    static let sharedInstance = Calculator()
    
    private init() {
       
        let today = Date()
        self.threeMonthDates = today.getDateRanges(type: DateType.lastThreeMonth)
        self.threeMonthDays = threeMonthDates.to.getIntervalDay(since: threeMonthDates.from)
        self.today = today.getValue(componet: .day)
        
    }
    
    public func getPercentValue(first: Double , divider: Double ) -> Double {
        
        if divider == 0 {
            return 0
        }
        
        return ((first - divider) * 100) / abs(divider);
    }
    
    public func getLastAction(filteredTransactions: [JoinedTransaction]) -> (LastAction)? {
        
        let cnt = filteredTransactions.count
        let tranIds = filteredTransactions.map {
            $0.transaction.id
        }
        
        guard let maxTransaction = getMaxTransactionByDate(transactions: filteredTransactions) else {
            return nil
        }
        
        
        let intervalDay = Date().getIntervalDay(since: maxTransaction.transaction.spentDate)
        return (cnt: cnt, keyword: maxTransaction.transaction.keyword, date: maxTransaction.transaction.spentDate.toMDStr(), day: intervalDay, tranIds: tranIds)

    }
    
    public func getMaxTransactionByDate(transactions: [JoinedTransaction]) -> JoinedTransaction? {
        return transactions.max(by: { (a, b) -> Bool in
            if a.transaction.spentDate == b.transaction.spentDate {
                if a.transaction.spentMoney == b.transaction.spentMoney {
                    return a.transaction.id < b.transaction.id
                } else {
                    return a.transaction.spentMoney < b.transaction.spentMoney
                }
            } else {
                return a.transaction.spentDate < b.transaction.spentDate
            }
        })
    }
    
    public func getMinTransactionByDate(transactions: [JoinedTransaction]) -> JoinedTransaction? {
        return transactions.max(by: { (a, b) -> Bool in
            if a.transaction.spentDate == b.transaction.spentDate {
                if a.transaction.spentMoney == b.transaction.spentMoney {
                    return a.transaction.id > b.transaction.id
                } else {
                    return a.transaction.spentMoney > b.transaction.spentMoney
                }
            } else {
                return a.transaction.spentDate > b.transaction.spentDate
            }
        })
    }
    
    //오전 7 <= 시간 < 10
    public func getMorningSum(filteredTransactions: [JoinedTransaction]) -> Morning {
        // date from <= , < to  and hour 7 >= 10 <
        
        
        let dateRanges = Date().getDateRanges(type: DateType.lastThreeMonth)
        let mornings = filteredTransactions.filter {
            
            let hour = $0.transaction.spentDate.getValue(componet: .hour)
            return $0.transaction.spentDate >= dateRanges.from && $0.transaction.spentDate < dateRanges.to && hour >= 7 && hour < 10
            
        }
        
        let sum = mornings.reduce(0, {$0 + $1.transaction.spentMoney})
        let tranIds = mornings.map {
            $0.transaction.id
        }
        
        return (sum: sum, tranIds: tranIds)
    
    }
    
}
