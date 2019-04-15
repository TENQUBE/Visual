//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
class Beauty : CommonCategory {
    
    let nailCode = "14"
    let hairCode = "11"
    
    var summary: BeautySummary?

    override init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)

        summary = self.makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 11:
                analysis = self.getContent11(content: content)
                break
            case 28:
                analysis = self.getContent28(content: content)
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

    func makeSummary() -> BeautySummary {

//        let dateRanges = Date().getDateRanges(type: DateType.lastThreeMonth)
        
//        let filteredTransactions = filterTransactions(from: dateRanges.from, to: dateRanges.to)

        let nailTransactions = filterTransactions(transactions: self.transactions
            , mcode: nailCode)
        
        let nail = calculator.getLastAction(filteredTransactions: nailTransactions)
        
        let hairTransactions = filterTransactions(transactions: self.transactions
            , mcode: hairCode)

        let hair = calculator.getLastAction(filteredTransactions: hairTransactions)
        
        let onceAday = getOnceADay(hairTransactions: hairTransactions)
        
        return BeautySummary(lastNail: nail, lastHair: hair, onceAday: onceAday)
        
    }
    
    func getOnceADay(hairTransactions: [JoinedTransaction]) -> Double {
        let dateRange = Date().getDateRanges(type: DateType.lastThreeMonth)
        
        let totalDay = Date().getIntervalDay(since: dateRange.from)
        let threeMonthCnt = hairTransactions.count
        
        // 몇일 에 한번 머리하는지 double
        return threeMonthCnt == 0 ? 0.0 :  Double(totalDay) / Double(threeMonthCnt)// 전체 일수 / 지난 3개월 헬스 카운트
        
    }
    
    func getContent11(content: Content) -> AnalysisResult? {
        //  11    2    1    0    46    180    뷰티/미용    지난3개월    네일 케어  받은 지 %1$s일 되었습니다.    180    마지막으로 케어 받은 날은↵%1$s (%2$s) 입니다.  ↵↵지난 3개월간 네일케어를 총 %3$s번 받았습니다.    168,169,170    lv0_mid_beauty_nail    뷰티/미용    마지막    1) 3개월,↵2) 네일    1) 마지막 결제일로부터 경과일 15일 이상↵2) 마지막 결제일로부터 경과일 90일  미만↵3) 홀수일    네일 케어  받은 지 15일 되었습니다.    마지막으로 케어 받은 날은↵5월 15일 (봉봉봉봉네일케어) 입니다.  ↵↵지난 3개월간 네일케어를 총 2번 받았습니다.    1    0    2018-07-22 14:33:37
        
        guard let summary = self.summary, let nail = summary.lastNail else {
            return nil
        }
        
//        let dayCondition = Date().getValue(componet: .day) % 2 != 0
        
        if  nail.day >= 15 && nail.day < 90 {
            
            let lContent = String(format: content.largeContent, nail.day.toNumberformat())
            
            let mContent = String(format: content.mediumContent, nail.date, nail.keyword, nail.cnt.toNumberformat())
            
            let tranIds = nail.tranIds
            
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
    
    func getContent28(content: Content) -> AnalysisResult? {
        //    28    2    1    0    46    179    뷰티/미용    지난3개월    마지막으로 머리 자른 지 ↵%1$s일 되었습니다.    179    마지막으로 머리 한 날은↵%1$s %2$s입니다. ↵↵보통 %3$s일에 1번 머리를 합니다.    171,172,173    lv0_mid_beauty_hairshop    뷰티/미용    마지막_헤어    1) 3개월,↵2) 헤어    1)마지막 결제일로부터 15일 이상 경과↵2)마지막 결제일로부터 경과일 90일  미만↵3) 짝수일    마지막으로 머리 자른 지 ↵15일 되었습니다.    마지막으로 머리 한 날은↵5월 15일 준오헤어커커입니다. ↵↵보통 3.1주일에 1번 머리를 합니다.    1    0    2018-07-22 14:39:17

       
        guard let summary = self.summary, let hair = summary.lastHair else{
            return nil
        }
        
       
        if hair.day >= 15 && hair.day < 90 {
            
            let lContent = String(format: content.largeContent, hair.day.toNumberformat())
            
            let mContent = String(format: content.mediumContent, hair.date, hair.keyword, summary.onceAday.toFirstDotFormat())
            
            let tranIds = hair.tranIds
            
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
