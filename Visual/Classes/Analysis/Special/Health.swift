//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

class Health : CommonCategory {
    
    let HOSPITAL = "13"
    let MID_PHARMACY = "14"
    let MID_DENTIST = "12"
    let MID_CLINIC = "11"
    var summary: HealthSummary?

    override init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)
        
        summary = self.makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 106:
                analysis = self.getContent106(content: content)
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
    
    func makeSummary() -> HealthSummary? {
    
//        let dateRanges = Date().getDateRanges(type: DateType.lastThreeMonth)
//
//        let filteredTransactions = filterTransactions(from: dateRanges.from, to: dateRanges.to)

        let healthTransactions = self.transactions.filter {
            $0.category.getMcode() == HOSPITAL ||
                $0.category.getMcode() == MID_PHARMACY ||
                $0.category.getMcode() == MID_DENTIST ||
                $0.category.getMcode() == MID_CLINIC
        }
    
        guard let maxTransaction = calculator.getMaxTransactionByDate(transactions: healthTransactions),
            let minTransaction = calculator.getMinTransactionByDate(transactions: healthTransactions) else {
                return nil
        }
        
        let diffDay = maxTransaction.transaction.spentDate.getIntervalDay(since: minTransaction.transaction.spentDate)
        
        return HealthSummary(minTransaction: minTransaction, maxTransaction: maxTransaction, diffDay: diffDay)
    }
    
    func getContent106(content: Content) -> AnalysisResult? {
        //106    2    1    0    44    164    의료/건강    지난3개월    늘 건강하시기 바랍니다.        %1$s일만에 의료비가 다시 발생했습니다.\n(이전 의료일: %2$s)\n\n아프지 말고 건강 챙기세요!    181,164    lv0_healthcare_else_2    의료/건강    건강기원    1) 3개월    1) 카테고리 내 지출 1회 이상↵2) 마지막 의료비지출일로부터 20일 이상 경과    늘 건강하시기 바랍니다.    00일만에 의료비가 다시 발생했습니다.↵(이전 의료일: 2015년 00월 00일)↵↵아프지 말고 건강 챙기세요!    1    0    2018-09-12 05:43:32
        
        guard let summary = self.summary else{
            return nil
        }

        if summary.diffDay > 20 {

            let mContent = String(format: content.mediumContent, summary.diffDay.toNumberformat(),
                                  summary.minTransaction.transaction.spentDate.toYMDStr())

            let tranIds = [summary.maxTransaction.transaction.id, summary.minTransaction.transaction.id]

            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:content.largeContent,
                             mContent:mContent,
                             tranIds: tranIds))
        }
        
        return nil
        
    }
        
        
}
