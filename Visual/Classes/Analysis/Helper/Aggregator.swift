//
//  Calculator.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation

enum AggregateType {
    case count
    case sum
    case avg
    case max
    case min
}

enum GroupByType {
    case month
    case day
    case keyword
    case largeCategory
    case midCategory
    case cardType
}

enum OrderByType {
    case asc
    case desc
}

class Aggregator {
        // filter -> select group by order by 결과 추출
    var aggregateType: AggregateType = .sum
    var groupByType: GroupByType = .month
    var orderByType: OrderByType = .desc
    
    var transactions: [JoinedTransaction]
    
    init(transactions: [JoinedTransaction]) {
        self.transactions = transactions
    }
    
    func select(type: AggregateType) -> Aggregator {
        self.aggregateType = type
        return self
    }
    
    func filterByDate(from:Date, to: Date) -> Aggregator {
        self.transactions = transactions.filter {
            $0.transaction.spentDate >= from && $0.transaction.spentDate < to
        }
        return self
    }
    
    func filterByLcode(lcode: Int) -> Aggregator {
        self.transactions = transactions.filter {
            $0.category.getLcode() == String(lcode)
        }
        
        return self
    }
    
    func group(by type: GroupByType) -> Aggregator {
        self.groupByType = type
        return self
    }
    
    func order(by type: OrderByType) -> Aggregator {
        self.orderByType = type
        return self
    }
    
    // 원하는 값 필터된 transactions 값으로 groupByType에 맞는 키별 aggregateType 값, tranId
    func execute() -> [AnalysisValue]? {
        
        let transactionDict = groupBy(type: self.groupByType, transactions: self.transactions)
        
        let results = aggregate(type: self.aggregateType, groupByType: self.groupByType, transactions: transactionDict)

        return orderBy(type: self.orderByType, groupByType: self.groupByType, resultDict: results)
        
    }
    
    func executeForDict() -> [String: AnalysisValue] {
        
        let transactionDict = groupBy(type: self.groupByType, transactions: self.transactions)
        
        let results = aggregate(type: self.aggregateType, groupByType: self.groupByType, transactions: transactionDict)

        return results
        
    }
    
    private func groupBy(type: GroupByType, transactions: [JoinedTransaction]) -> [String: [JoinedTransaction]] {
        switch type {
        case .month:
            return Dictionary(grouping: transactions, by: { $0.transaction.spentDate.toYMStr() })
            
        case .day:
            return Dictionary(grouping: transactions, by: { $0.transaction.spentDate.toDayStr() })
            
        case .keyword:
            return Dictionary(grouping: transactions, by: { $0.transaction.keyword })
            
        case .largeCategory:
            return Dictionary(grouping: transactions, by: { $0.category.getLcode() })
            
        case .midCategory:
            return Dictionary(grouping: transactions, by: { $0.category.getMcode() })
            
        case .cardType:
            return Dictionary(grouping: transactions, by: { String($0.card.changeType) })
            
        }
    }
    
    private func aggregate(type: AggregateType, groupByType: GroupByType, transactions: [String: [JoinedTransaction]]) -> [String: AnalysisValue] {
        
        var results: [String: AnalysisValue] = [:]
        
        for (key, values) in transactions {
            let key = key
            var amount: Double = 0
            var tranIds = values.map {$0.transaction.id}
            var transaction = values[0]
            
            switch type {
            case .count:
                let cnt = values.count
                amount = Double(cnt)
                break
                
            case .sum:
                amount = values.reduce(0,  { $0 + $1.transaction.spentMoney })
                break
                
            case .avg:
                let cnt = values.count
                let sum = values.reduce(0,  { $0 + $1.transaction.spentMoney })
                amount = sum / Double(cnt)
                break
                
            case .max:
                guard let maxTransaction = values.max(by: { (a, b) -> Bool in
                    if a.transaction.spentMoney == b.transaction.spentMoney {
                        if a.transaction.spentDate == b.transaction.spentDate {
                            return a.transaction.id < b.transaction.id
                        } else {
                            return a.transaction.spentDate < b.transaction.spentDate
                        }
                    } else {
                        return a.transaction.spentMoney < b.transaction.spentMoney
                    }
                }) else {
                    continue
                }
                
                transaction = maxTransaction
                tranIds = [transaction.transaction.id]
                amount = transaction.transaction.spentMoney
                break
                
            case .min:
                guard let minTransaction = values.max(by: { (a, b) -> Bool in
                    if a.transaction.spentMoney == b.transaction.spentMoney {
                        if a.transaction.spentDate == b.transaction.spentDate {
                            return a.transaction.id > b.transaction.id
                        } else {
                            return a.transaction.spentDate > b.transaction.spentDate
                        }
                    } else {
                        return a.transaction.spentMoney > b.transaction.spentMoney
                    }
                }) else {
                    continue
                }
                
                transaction = minTransaction
                tranIds = [transaction.transaction.id]
                amount = transaction.transaction.spentMoney
                
                break
            }
            
            results[key] = AnalysisValue(key: key, amount: amount, tranIds: tranIds, transaction: transaction)
            
        }
        
        return results
        
        
    }
    
    // double 값에 맞게
    private func orderBy(type: OrderByType, groupByType: GroupByType, resultDict: [String: AnalysisValue]) -> [AnalysisValue]? {
 
        let results = resultDict.flatMap {
            [$0.value]
        }
        
        if(results.count == 0) {
            return nil
        }
        
        switch groupByType {
        case .month:
            
            return results.sorted(by: {
                
                if type == .asc {
                    return $0.transaction!.transaction.spentDate > $1.transaction!.transaction.spentDate
                } else {
                    return $0.transaction!.transaction.spentDate < $1.transaction!.transaction.spentDate
                }
            })
            
        default:
            return results.sorted(by: {
                
                if type == .asc {
                    return $0.amount < $1.amount // asc
                } else {
                     return $0.amount > $1.amount // desc
                }
            })
    
        }
    
    }

}
