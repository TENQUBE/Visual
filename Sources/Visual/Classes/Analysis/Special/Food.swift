//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

class Food : CommonCategory{

    let FASTFOOD = "12"
  
    var summary: FoodSummary?
    
    override init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)
        
        summary = self.makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 13:
                analysis = self.getContent13(content: content)
                break
            default:
                break
            }
            
            if let analysis = analysis {
                analysies.append(analysis)
            }
        }
        return analysies
    }
    
    func makeSummary() -> FoodSummary? {
        
   
        let dateRanges = Date().getDateRanges(type: DateType.lastThreeMonth)
        let filteredTransactions = filterTransactions(from: dateRanges.from, to: dateRanges.to)
        
        let foodCnt = filteredTransactions.count
        if foodCnt == 0 {
            return nil
        }
        
        
        let fastFoodTransactions = filterTransactions(transactions: filteredTransactions, mcode: FASTFOOD)
        
        let fastFoodCnt = fastFoodTransactions.count


        if fastFoodCnt == 0 {
            return nil
        }
        
        let percent = Double(fastFoodCnt) * 100 / Double(foodCnt)
  
        guard let fastFoods = Aggregator(transactions: fastFoodTransactions).select(type: .count).group(by: .keyword).execute() else {
            return nil
        }
        

        let tranIds = filteredTransactions.map {
            $0.transaction.id
        }
        
        return FoodSummary(foodCnt: foodCnt, fastFoodCnt: fastFoodCnt, percent: percent, fastFoods: fastFoods, tranIds: tranIds)
    }
    
    func getContent13(content: Content) -> AnalysisResult? {
        //13    2    1    0    22    186    외식    지난3개월    지난 3개월 동안\n총 %1$s회 외식하였습니다.    186    이 중 패스트푸드는 %1$s회 (%2$s)입니다. \n%3$s 순입니다.    188,189,241    lv0_mid_food_fastfood    외식    fastfood    1) 3개월,↵2) 패스트푸드    1) 전체외식 수 > 5회,↵2) 패스트푸드 횟수 % > 10%    지난 3개월 동안↵총 22회 외식하였습니다.    이 중 패스트푸드는 12회 (33%)입니다. ↵맥도날드 5회,  KFC2회,↵광광광 1회 순입니다.    1    2    2018-09-12 05:43:32

        guard let summary = self.summary else{
            return nil
        }
        
  
        
        if summary.foodCnt > 5 &&
            summary.percent > 10 {
            
            let lContent = String(format: content.largeContent, summary.foodCnt.toNumberformat())
            
            let mContent = String(format: content.mediumContent, summary.fastFoodCnt.toNumberformat(),
                                  summary.percent.toPercent(),
                                  analysisUtil.getMediumCntStrWithPercent(results: summary.fastFoods, cnt: summary.foodCnt))
            
            let tranIds = summary.tranIds
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:lContent,
                             mContent:mContent,
                             tranIds: tranIds))
        }
        
        return nil
        
    }
    
    
 
}
