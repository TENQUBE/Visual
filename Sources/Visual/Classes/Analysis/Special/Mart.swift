//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

class Mart : CommonCategory {
    
    let MART = "16"
    let CONVENIENCE = "11"

    var summary: MartSummary?
    
    override init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)
        
        self.summary = makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 32:
                analysis = self.getContent32(content: content)
                break
            case 33:
                analysis = self.getContent33(content: content)
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
    
    func makeSummary() -> MartSummary {
        
        let martMonths = self.getMonths(mcode: MART)
        
        let convenienceMonths = self.getMonths(mcode: MART)
        
        return MartSummary(martMonths: martMonths,
                           convenienceMonths: convenienceMonths)
        
    }
    
    func getMonths(mcode: String) -> [MartValue] {
        
        var months = [MartValue]()
        for i in 1..<4 { //이번달 정보 없음
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
    
   
    
    func getContent32(content: Content) -> AnalysisResult? {
        
        //    32    2    1    0    32    56    생활/마트    지난달    지난 달 마트에서 ↵%1$s 지출했습니다.    56    %1$s월 %2$s,↵%3$s월 %4$s,↵%5$s월 %6$s으로↵↵3개월 동안 마트 지출은 %7$s입니다.    28,56,69,97,99,127,131    lv0_mid_mart_grocery    생활/마트    지난달_마트    1) 3개월,↵2) 마트    2) 지난 달 마트 값 > 4만원,    지난 달 마트에서 ↵35.1만원 지출했습니다.    7월 10.2만원,↵6월 15.2만원,↵5월 2.1만원으로↵↵3개월 동안 마트에서 쓴 돈은 111.1만원입니다.    1    0    2018-07-22 14:41:23
        guard let summary = self.summary else{
            return nil
        }
        
        if summary.martMonths[0].sum > 40000 {
            
            let lContent = String(format: content.largeContent, summary.martMonths[0].sum.toLv0Format())
            
            let sumOfThreeMonth = summary.martMonths.reduce(0, {$0 + $1.sum})
            
            let mContent = String(format: content.mediumContent, summary.martMonths[0].month.toStr(), summary.martMonths[0].sum.toLv0Format(),
                                  summary.martMonths[1].month.toStr(), summary.martMonths[1].sum.toLv0Format(),
                                  summary.martMonths[2].month.toStr(), summary.martMonths[2].sum.toLv0Format(),
                                  sumOfThreeMonth.toLv0Format())
            
            let tranIds = summary.martMonths[0].tranIds
            
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
    
    func getContent33(content: Content) -> AnalysisResult? {
        //    33    2    1    0    32    57    생활/마트    지난달    지난 달, 편의점에서 ↵%1$s 지출했습니다.    57    %1$s월 %2$s,↵%3$s월 %4$s,↵%5$s월 %6$s으로↵↵편의점에서 3개월 동안 %7$s 지출했습니다.    28,57,69,98,99,128,132    lv0_mid_mart_conveni    생활/마트    지난달_편의점    1) 3개월,↵2) 편의점    2) 지난 달 편의점 > 4만원,    지난 달, 편의점에서 ↵10.2만원 지출했습니다.    7월 10.2만원,↵6월 15.2만원,↵5월 2.1만원으로↵↵편의점에서 3개월 동안 111.1만원 썼습니다.    1    0    2018-07-22 14:42:05

        guard let summary = self.summary else{
            return nil
        }
        
        if summary.convenienceMonths[0].sum > 40000 {
            
            let lContent = String(format: content.largeContent, summary.convenienceMonths[0].sum.toLv0Format())
            
            let sumOfThreeMonth = summary.martMonths.reduce(0, {$0 + $1.sum})
            
            let mContent = String(format: content.mediumContent, summary.convenienceMonths[0].month.toStr(), summary.convenienceMonths[0].sum.toLv0Format(),
                                  summary.convenienceMonths[1].month.toStr(), summary.convenienceMonths[1].sum.toLv0Format(),
                                  summary.convenienceMonths[2].month.toStr(), summary.convenienceMonths[2].sum.toLv0Format(),
                                  sumOfThreeMonth.toLv0Format())
            
            let tranIds = summary.convenienceMonths[0].tranIds
            
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
