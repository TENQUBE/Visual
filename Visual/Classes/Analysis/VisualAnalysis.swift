//
//  VisualAnalysis.swift
//  Visual
//
//  Created by tenqube on 07/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

import Foundation
class VisualAnalysis: Analysis {
    

    let calculator: Calculator
    let analysisUtil: AnalysisUtil
    
    var transactions: [JoinedTransaction]
    var contents: [Content]
//    let contents: [Content]
    
    init(contents: [Content], transactions: [JoinedTransaction]) {
        
        self.contents = contents
        self.transactions = transactions
        
        self.calculator = Calculator.sharedInstance
        self.analysisUtil = AnalysisUtil.sharedInstance
    }
    
    func getContents() -> [AnalysisResult] {
        return []
        
    }
}
