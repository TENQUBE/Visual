//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
class Culture : CommonCategory {
    
    let movieCode = "11"
    let bookCode = "12"
    let avgOfBookSum = 54300.0
    
    var summary: CultureSummary?
    
    override init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)
        
        summary = self.makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 12:
                analysis = self.getContent12(content: content)
                break
            case 189:
                analysis = self.getContent189(content: content)
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
    
    func makeSummary() -> CultureSummary {
        
//        let dateRanges = Date().getDateRanges(type: DateType.lastThreeMonth)
        
//        let filteredTransactions = filterTransactions(from: dateRanges.from, to: dateRanges.to)
        
        let movieTransactions = filterTransactions(transactions: self.transactions,
                                                   mcode: movieCode)
        
        let movie = calculator.getLastAction(filteredTransactions: filterTransactions(transactions: movieTransactions, mcode: movieCode))
 
    
        
        let bookTransactions = filterTransactions(transactions: self.transactions,
                                                  mcode: bookCode)
        
        let bookSum = bookTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
        
        let bookTranIds = bookTransactions.map {
            $0.transaction.id
        }

        return CultureSummary(lastMovie: movie, lastThreeMonthBookSum: (sum: bookSum, tranIds: bookTranIds))
    }
    
    func getContent12(content: Content) -> AnalysisResult? {
   //    12    2    1    0    56    182    문화/예술    지난3개월    영화 본 지 %1$s일 지났습니다.    182    마지막으로 영화 본 날은\n%1$s (%2$s) 입니다.  \n\n지난 3개월, 영화를 %3$s번 봤습니다.     165,166,167    lv0_mid_culture_movies    문화/예술    마지막    1) 3개월,↵2) 영화    1) 마지막 결제일로부터 경과일 15일 이상↵2) 마지막 결제일로부터 경과일 90일  미만↵3) 짝수일    영화 본 지 15일 지났습니다.    마지막으로 영화 본 날은↵5월 15일 (영등포타임스퀘어 CGV) 입니다.  ↵↵지난 3개월, 영화를 2번 봤습니다.     1    0    2018-09-12 05:43:32
        guard let summary = self.summary, let movie = summary.lastMovie else{
            return nil
        }
    
        if movie.day >= 15 && movie.day < 90 {
            
            let lContent = String(format: content.largeContent, movie.day.toNumberformat())
            
            let mContent = String(format: content.mediumContent, movie.date, movie.keyword, movie.cnt.toNumberformat())
            
            let tranIds = movie.tranIds
            
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
    
    func getContent189(content: Content) -> AnalysisResult? {
   //    189    2    1    0    56    137    문화/예술     지난3개월    지난 3개월 간 도서 구입비로 %1$s을 지출했습니다.    137    이는 가구당 월평균 도서구입비보다 \n%1$s 더 많습니다.\n책에는 아끼지 않는 당신, 멋지네요!    227    lv0_culture_bookreader    문화/예술    지성인    1) 3개월↵2) 도서    지난 3개월 누적 지출액 > 54300원    지난 3개월 간 도서 구입비로 00000원을 지출했습니다.    이는 2014년 기준 가구당 월평균 도서구입비보다 ↵000원 더 많습니다.↵책에는 아끼지 않는 당신, 멋지네요!    1    0    2018-09-12 05:43:32
        guard let summary = self.summary else{
            return nil
        }
        
        if summary.lastThreeMonthBookSum.sum > avgOfBookSum {
            
            let lContent = String(format: content.largeContent,summary.lastThreeMonthBookSum.sum.toLv0Format())
            
            let diff = summary.lastThreeMonthBookSum.sum - avgOfBookSum
            
            let mContent = String(format: content.mediumContent, diff.toLv0Format())
            
            let tranIds = summary.lastThreeMonthBookSum.tranIds
            
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
