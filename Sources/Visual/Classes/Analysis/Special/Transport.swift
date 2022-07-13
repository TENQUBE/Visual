//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
class Transport : CommonCategory {
    
    let TAXI = "16"

    var summary: TransportSummary?
    
    override init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)
        
        self.summary = makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 27:
                analysis = self.getContent27(content: content)
                break
            case 34:
                analysis = self.getContent34(content: content)
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
    
    func makeSummary() -> TransportSummary {
        
        let taxiMonths = self.getMonths(mcode: TAXI)
        
        let dateRanges = Date().getDateRanges(type: DateType.lastThreeMonth)
        
        let filteredTransactions = filterTransactions(from: dateRanges.from, to: dateRanges.to)

        let taxiTransactions = filterTransactions(transactions: filteredTransactions, mcode: TAXI)
        
        let sumOfMorning = calculator.getMorningSum(filteredTransactions: taxiTransactions)
        
        let sumOfThreeMonth = taxiMonths.reduce(0, {$0 + $1.sum})
        return TransportSummary(sumOfMorning: sumOfMorning,
                                taxiMonths: taxiMonths,
                                sumOfThreeMonth: sumOfThreeMonth)
    }
    
    func getMonths(mcode: String) -> [TransportValue] {
        
        var months = [TransportValue]()
        for i in 1..<4 {
            let dateRanges = Date().getDateRanges(type: DateType.month(i))
            
            let month = dateRanges.from.getValue(componet: .month)
            
            let filteredTransactions = filterTransactions(transactions: filterTransactions(from: dateRanges.from, to: dateRanges.to),
                                                          mcode: mcode)
            
            let sum = filteredTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
            
            let tranIds = filteredTransactions.map {
                $0.transaction.id
            }
            
            months.append((month: month, sum: sum, tranIds: tranIds))
        }
        
        return months
    }
    
    func getContent27(content: Content) -> AnalysisResult? {
        
  //    27    2    1    0    62    136    교통/차량    지난3개월    3개월 동안 ↵늦잠의 가격은 %1$s!    136    %1$s월, %2$s월, %3$s월 택시 지출은 %4$s입니다.↵이 중 오전에 결제한 택시 지출이 %5$s입니다.    99,69,28,135,136    lv0_transportation_taxi_morning_late    교통/차량    택시-늦잠    1) 3개월,↵2) 택시    1) 3개월 소분류 오전 택시 사용금액>10만원    3개월 동안 ↵늦잠의 가격은 12.1만원!    5월, 6월, 7월 택시비는 32.1만원입니다.↵이 중 오전에 탄 택시비는 12.1만원입니다.    1    0    2018-07-23 13:55:46
        guard let summary = self.summary else{
            return nil
        }
        
        if summary.sumOfMorning.sum > 100000 {
            
            let lContent = String(format: content.largeContent, summary.sumOfMorning.sum.toLv0Format())
            
            let mContent = String(format: content.mediumContent, summary.taxiMonths[2].month.toStr(),
                                                                  summary.taxiMonths[1].month.toStr(),
                                                                  summary.taxiMonths[0].month.toStr(),
                                                                  summary.sumOfThreeMonth.toLv0Format(),
                                                                  summary.sumOfMorning.sum.toLv0Format())
            
            let tranIds = summary.sumOfMorning.tranIds
            
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
    
    func getContent34(content: Content) -> AnalysisResult? {
        //    34    2    1    0    62    201    교통/차량    지난달    지난 달 택시 지출은↵%1$s입니다.    201    %1$s월 %2$s,↵%3$s월 %4$s,↵%5$s월 %6$s으로↵↵3개월 동안 택시 지출은 %7$s입니다.    28,201,69,219,99,223,135    lv0_mid_transportation_taxi    교통/차량    택시값    1) 3개월,↵2) 택시    2) 지난 달 택시 값 > 4만원,    지난 달 택시 지출은↵10.2만원입니다.    7월 10.2만원,↵6월 15.2만원,↵5월 2.1만원으로↵↵3개월 동안의 택시비는 111.1만원입니다.    1    0    2018-07-22 14:42:42

        guard let summary = self.summary else{
            return nil
        }
        
        if summary.taxiMonths[0].sum > 40000 {
            
            let lContent = String(format: content.largeContent, summary.taxiMonths[0].sum.toLv0Format())
            
            
            let mContent = String(format: content.mediumContent, summary.taxiMonths[0].month.toStr(), summary.taxiMonths[0].sum.toLv0Format(),
                                  summary.taxiMonths[1].month.toStr(), summary.taxiMonths[1].sum.toLv0Format(),
                                  summary.taxiMonths[2].month.toStr(), summary.taxiMonths[2].sum.toLv0Format(),
                                  summary.sumOfThreeMonth.toLv0Format())
            
            let tranIds = summary.taxiMonths[0].tranIds
            
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
