//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation
class CommonCategory: VisualAnalysis {
    
    var categoryType: CategoryType?
    
    var categorySummaries: [CategorySummary?]?
    
    init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        super.init(contents: contents, transactions: transactions)
        
        self.categoryType = categoryType
       
        self.categorySummaries = [CategorySummary]()
        
        for i in 0..<2 {
        
            self.categorySummaries?.append(makeCategorySummary(before: i))
        }
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = [AnalysisResult]()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 23:
                analysis = self.getContent23(content: content)
                break
            case 24:
                analysis = self.getContent24(content: content)
                break
                
            case 137:
                analysis = self.getContent137(content: content)
                break
                
            case 138:
                analysis = self.getContent138(content: content)
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
    
    func makeCategorySummary(before: Int) -> CategorySummary? {
        
        let dateRanges = Date().getDateRanges(type: DateType.month(before))
        
        let filteredTransactions = self.filterTransactions(from: dateRanges.from, to: dateRanges.to)
        let name = filteredTransactions.first?.category.large ?? ""
        let month = dateRanges.0.getValue(componet: .month)
        
        let sum = filteredTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
        
        guard let maxTransaction = Aggregator(transactions: filteredTransactions).select(type: .max).group(by: .keyword).execute()?.first?.transaction else {
            return nil
        }

        guard let sumByMedium = Aggregator(transactions: filteredTransactions).select(type: .sum).group(by: .midCategory).execute() else {
            return nil
        }

        let tranIds = filteredTransactions.map {
            $0.transaction.id
        }
        return CategorySummary(name: name, month: month, sum: sum, maxTransaction: maxTransaction, sumByMedium: sumByMedium, tranIds: tranIds)
    
    }
    
    func filterTransactions(transactions: [JoinedTransaction], mcode: String) -> [JoinedTransaction] {
        return transactions.filter {
            $0.category.getMcode() == mcode
        }
    }
    
    func filterTransactions(transactions: [JoinedTransaction]) -> [JoinedTransaction] {
        
        guard let categoryType = self.categoryType else {
            return []
        }
        
        return transactions.filter {
            Int($0.category.getLcode()) == categoryType.rawValue
        }
    }
    
    func filterTransactions(from: Date, to: Date) -> [JoinedTransaction] {
    
        return transactions.filter {
            $0.transaction.spentDate >= from && $0.transaction.spentDate < to
        }
    }
    
    func makeMaxKeyword(content: Content, before: Int) -> AnalysisResult? {
        
        guard let summaries = self.categorySummaries,
        let summary = summaries[before] else{
            return nil
        }
        
        if summary.sum > 100000 {
            
            guard let maxTransaction = summary.maxTransaction else {
                return nil
            }
            
            let lContent = String(format: content.largeContent, summary.name, summary.sum.toLv0Format())
            
            let mValue = "\(maxTransaction.transaction.keyword)(\(maxTransaction.transaction.spentMoney.toLv0Format()))"
            
            let mContent = String(format: content.mediumContent, mValue)
            
            let tranIds = summary.tranIds
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:analysisUtil.getLargeImage(lcode: self.categoryType!.rawValue),
                             label:summary.name,
                             lContent:lContent,
                             mContent:mContent,
                             tranIds: tranIds))
        }
        
        return nil
        
    }
    
    func getContent137(content: Content) -> AnalysisResult? {
    
        //    137    2    1    0    0        0    이번달    이번 달 %1$s 지출은\n%2$s 입니다.        주요 지출처는\n%1$s 입니다.    0    0    카테고리    카테고리 주요    이번달    이번달 건수 > 1, 합 > 100000    이번 달 %1$s 지출은\n22만원입니다.    주요 지출처는\n%(스타벅스 22만원)입니다.    1    3    2018-09-12 05:48:37
        return makeMaxKeyword(content: content, before: 0)
    }
    
    func getContent23(content: Content) -> AnalysisResult? {
        //23    2    1    0    0        0    지난달    지난달 %1$s 지출은\n%2$s 입니다.        주요 지출처는\n%1$s 입니다.    0    0    카테고리    지난달 요약    지난달    지난달 건수 > 1, 합 > 100000    지난달 %1$s 지출은\n22만원입니다.    주요 지출처는\n%(스타벅스 22만원)입니다.    1    3    2018-09-12 05:47:47
        return makeMaxKeyword(content: content, before: 1)
    }
    
    func getMediumContent(content: Content, before: Int) -> AnalysisResult? {
        guard let summaries = self.categorySummaries,
            let summary = summaries[before] else{
                return nil
        }
        
        let dayCondition = before == 0 ? true : Date().getValue(componet: .day) <= 20
        
        if dayCondition &&
            summary.sum > 50000 &&
            summary.sumByMedium.count >= 2 {
            
            let lContent = before == 0 ?
                String(format: content.largeContent, summary.name, summary.sum.toLv0Format())
                :
                String(format: content.largeContent, String(summary.month), summary.name, summary.sum.toLv0Format())
            
            guard let topMidum = summary.sumByMedium.first, let tran = topMidum.transaction else {
                return nil
            }
            
            let image = analysisUtil.getMediumImage(lcode: tran.category.getMcode(),
                                                    mcode: tran.category.getLcode())
            
    
            let mContent = before == 0 ?
                String(format: content.mediumContent, AnalysisUtil.sharedInstance.getMediumStr(results: summary.sumByMedium))
                :
                String(format: content.mediumContent, summary.name, AnalysisUtil.sharedInstance.getMediumStrWithPercent(results: summary.sumByMedium, sum: summary.sum))
            
            
            let tranIds = summary.tranIds
            
            return AnalysisResult((id:content.id,
                                   categoryPriority:content.categoryPriority,
                                   image:image,
                                   label:summary.name,
                                   lContent:lContent,
                                   mContent:mContent,
                                   tranIds: tranIds))
        }
        
        return nil
    }
    
    func getContent24(content: Content) -> AnalysisResult? {
        
//        24    2    0    0    0        지난달    0    %@월 %@ 지출은 \n%@입니다.        %@ 지출의 주요 항목은\n%@ 입니다.    0    0
        //24    2    0    0    0    198    199    지난달    %1$s월 %2$s지출은 ↵%3$s입니다.    28,199,198    %s 지출의 주요 항목은↵$@입니다.    199,59,60,61,62,63,64,65,66,67    238    카테고리    지난달 요약    1) 지난 달,↵2) 중분류    1) 대카테고리 사용금액>5만원,↵2) mid카테 2개 이상↵3) 날짜 : 20일 이전    10월 백화점/패션 지출은 ↵2,512.1만원입니다.↵↵(*저거 10월 = 지난 달 임)    백화점/패션 지출의 주요 항목은↵1위 아울렛 (31.2만원, 32%)↵2위 의류 (32.1만원, 32%) 입니다.    1    0    2018-07-23 03:59:06
       
        return getMediumContent(content: content, before: 1)

    }
    
    func getContent138(content: Content) -> AnalysisResult? {
   
        //    138    2    1    0    0        0    이번달    이번 달 %1$s 지출은\n%2$s 입니다.        지출의 주요 항목은\n%1$s입니다.    0    0    카테고리    카테고리 주요    이번달    중분류 갯수 > 1    이번 달 카페/간식 지출은\n22만원입니다.    지출의 주요 항목은\n1위 커피 (22만원),\n2위 아이스크림(21만원)입니다.    1    3    2018-09-12 05:48:45

        return getMediumContent(content: content, before: 0)
    }
}
