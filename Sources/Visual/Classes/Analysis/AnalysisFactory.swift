//
//  FactoryAnalysis.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

enum AnalysisFactory {

    static func create(for categoryType : CategoryType, contents: [Content], transactions: [JoinedTransaction]) -> Analysis {
        
        switch categoryType {
        case .monthly:
            return Monthly(contents: contents, transactions: transactions)
        case .weekly:
            return Weekly(contents: contents, transactions: transactions)
        case .daily:
            return Daily(contents: contents, transactions: transactions)
        case .alcohol:
            return Alcohol(contents: contents, transactions: transactions, categoryType: categoryType)
        case .beauty:
            return Beauty(contents: contents, transactions: transactions, categoryType: categoryType)
        case .cafe:
            return Cafe(contents: contents, transactions: transactions, categoryType: categoryType)
        case .transport:
            return Transport(contents: contents, transactions: transactions, categoryType: categoryType)
        case .culture:
            return Culture(contents: contents, transactions: transactions, categoryType: categoryType)
        case .food:
            return Food(contents: contents, transactions: transactions, categoryType: categoryType)
        case .health:
            return Health(contents: contents, transactions: transactions, categoryType: categoryType)
        case .mart:
            return Mart(contents: contents, transactions: transactions, categoryType: categoryType)
            
        default:
            return CommonCategory(contents: contents, transactions: transactions, categoryType: categoryType)
        }
    }
    
}
