//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
class Alcohol : CommonCategory {
    
    let beearCode = "13"

    var summary: AlcoholSummary?
    
    override init(contents: [Content], transactions: [JoinedTransaction], categoryType: CategoryType) {
        
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)
        
        self.summary = makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 31:
                analysis = self.getContent31(content: content)
                break
            case 93:
                analysis = self.getContent93(content: content)
                break
            case 97:
                analysis = self.getContent97(content: content)
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
    
    func makeSummary() -> AlcoholSummary {

        let months = getMonths() // 월, 건, 합, tranIds

        let alcoholTypes = getAlcoholType(cnt: months[1].cnt)

        let alcoholType = alcoholTypes.0
        let alcoholTypeImg = alcoholTypes.1

        let yesterdaySum = getYesterdaySum()

        let lastThreeMonthSum = self.getLastThreeMonthSum(months: months)

        return AlcoholSummary(months: months,
                              alcoholType: alcoholType,
                              alcoholTypeImg: alcoholTypeImg,
                              yesterdaySum: yesterdaySum,
                              lastThreeMonthSum: lastThreeMonthSum)
    }

    func getMonths() -> [Beer] {

        var months = [Beer]()
        for i in 1..<4 {// 이번달 정보 없음
            let dateRanges = Date().getDateRanges(type: DateType.month(i))
            
            let month = dateRanges.from.getValue(componet: .month)
            
            let filteredTransactions = filterTransactions(transactions: filterTransactions(from: dateRanges.from, to: dateRanges.to),
                                                          mcode: beearCode)
            
            let cnt = filteredTransactions.count
            
            let sum = filteredTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
            
            let tranIds = filteredTransactions.map {
                $0.transaction.id
            }
            
            months.append((month: month, cnt: cnt, sum: sum, tranIds: tranIds))
        }
        
        return months
    }

    func getAlcoholType(cnt: Int) -> (String, String) {

        if(cnt == 0){
            return ("비음주", "lv0_alcohol_type_no_alcohol")
        } else if(cnt > 0 && cnt <= 2) {
            return ("건강 중시형", "lv0_alcohol_type_healthy")
        } else if(cnt > 2 && cnt <= 5) {
            return ("스트레스 해소", "lv0_alcohol_type_stress_down")
        } else if(cnt > 5 && cnt <= 8) {
            return ("애주가형", "lv0_alcohol_type_lover")
        } else if(cnt > 8) {
            return ("밥보다 술", "lv0_alcohol_type_prefer_al")
        } else {
            return ("비음주", "lv0_alcohol_type_no_alcohol")
        }
    }

    func getYesterdaySum() -> Double {
       
        let today = Date()
        let todayYmd = "\(today.toDayStr()) 04:00:00"
        
        guard let yesterday = today.addDay(day: -1) else {
            return 0
        }
        
        let yesterdayYmd = "\(yesterday.toDayStr()) 20:00:00"
        
        guard let from = yesterdayYmd.toDate(), let to = todayYmd.toDate() else {
            return 0
        }
        
        let filteredTransactions = transactions.filter {
            $0.transaction.spentDate >= from && $0.transaction.spentDate < to &&
                $0.category.getMcode() == beearCode
        }
        
        return filteredTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
    }

    func getLastThreeMonthSum(months: [Beer]) -> Double {
        return months.reduce(0, {$0 + $1.sum})
    }
    
    func getContent31(content: Content) -> AnalysisResult? {
        //    31    2    1    0    26    54    술/유흥    지난달    지난 달, 술 지출은↵%1$s입니다.    54    %1$s월 %2$s,↵%3$s월 %4$s,↵%5$s월 %6$s으로↵↵3개월 동안 술 지출은 %7$s입니다.    28,54,69,95,99,125,129    lv0_mid_alcohol_soolzip    술/유흥    지난달_술    1) 3개월,↵2) 술집    2) 지난 달 술집 값 > 4만원,    지난 달, 술 지출은↵10.2만원입니다.    7월 10.2만원,↵6월 15.2만원,↵5월 2.1만원으로↵↵3개월 동안 술 지출은 111.1만원입니다.    1    0    2018-07-22 14:40:53
        guard let summary = self.summary else{
            return nil
        }
        
        if summary.months[0].sum > 40000 {
            
            let lContent = String(format: content.largeContent, summary.months[0].sum.toLv0Format())
            
            
            let mContent = String(format: content.mediumContent, summary.months[2].month.toStr(), summary.months[2].sum.toLv0Format(),
                                       summary.months[1].month.toStr(), summary.months[1].sum.toLv0Format(),
                                       summary.months[0].month.toStr(), summary.months[0].sum.toLv0Format(),
                                       summary.lastThreeMonthSum.toLv0Format())
            
            let tranIds = summary.months[0].tranIds
            
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

    func getContent93(content: Content) -> AnalysisResult? {
        //    93    2    1    0    26    208    술/유흥    이번달    어제 술자리는 즐거우셨나요?        어제 술 지출은 %1$s입니다.↵↵3개월 동안 술 지출은 %2$s입니다.    208,129    lv0_alcohol_soolzip_yesterday    술/유흥    어제술    3개월    1) 어제 20:00~오늘 04:00 술집 지출 > 3만원↵2) 3개월 술집 지출 > 어제 20:00~오늘 04:00 술집 지출    어제 술자리는 즐거우셨나요?    어제 술 지출은 5.3만원입니다.↵↵3개월 동안 술 지출은 111.1만원입니다.    1    0    2018-07-22 14:45:52

        guard let summary = self.summary else{
            return nil
        }
        
        if summary.yesterdaySum > 30000 &&
           summary.lastThreeMonthSum > summary.yesterdaySum {
            
            let mContent = String(format: content.mediumContent, summary.yesterdaySum.toLv0Format(), summary.lastThreeMonthSum.toLv0Format())
            
            let tranIds = summary.months[0].tranIds
            
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

    func getContent97(content: Content) -> AnalysisResult? {
        //    97    2    1    0    26    54    술/유흥    지난달    지난달 나의 음주유형은↵%1$s 입니다    204    지난달 술집 결제 건수는 %1$s건이며↵%2$s을 지출하였습니다. ↵↵3개월 동안 술 지출은 %3$s입니다.    68,54,129    229    술/유흥    술타입    1) 지난 달,↵2) 술집    1) 3개월 누적 술집 지출 > 10만원↵2) 남자    지난달 나의 음주유형은↵'스트레스 해소형' 입니다    지난달 술집 결제 건수는 3건이며↵14만원을 지출하였습니다. ↵↵3개월 동안 술 지출은 11.1만원입니다.    1    0    2018-07-23 13:55:49
    
        guard let summary = self.summary else{
            return nil
        }
        
        if summary.months[0].sum > 0 &&
            summary.lastThreeMonthSum > 100000 {
            
            let lContent = String(format: content.largeContent, summary.alcoholType)
            
            
            let mContent = String(format: content.mediumContent,summary.months[0].cnt.toStr(), summary.months[0].sum.toLv0Format(), summary.lastThreeMonthSum.toLv0Format())
            
            let tranIds = summary.months[0].tranIds
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:summary.alcoholTypeImg,
                             label:content.label,
                             lContent:lContent,
                             mContent:mContent,
                             tranIds: tranIds))
        }
    
        return nil
    }
    
}
