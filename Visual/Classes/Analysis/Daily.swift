
class Daily: VisualAnalysis {
    
    var dailySummary: DailySummary?
    
    var weeklySum: Double?
    
    override init(contents: [Content], transactions: [JoinedTransaction]) {
        super.init(contents: contents, transactions: transactions)
        self.dailySummary = self.makeDailySummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = [AnalysisResult]()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 91:
                analysis = getContent91(content: content)
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
    
    func makeDailySummary() -> DailySummary {
     
        let filteredTransactions = filterTransactions()
        
        let tranIds = getTranIds(filteredTransactions: filteredTransactions)
        
        let sum = getSum(filteredTransactions: filteredTransactions)
        
        let maxTran = getMaxTransaction(filteredTransactions: filteredTransactions)
        
        // 일평균
        let dailyAvgOf12Week = getAvgOf90Day()
      
        return DailySummary(sum: sum, maxTransaction: maxTran, dailyAvgOf12Week: dailyAvgOf12Week, tranIds: tranIds)
    
    }
    
    func filterTransactions() -> [JoinedTransaction] {
        
        let dateRanges = Date().getDateRanges(type: DateType.day(1))
        
        return self.transactions.filter {
            $0.transaction.spentDate >= dateRanges.from && $0.transaction.spentDate < dateRanges.to
        }
        
    }
    
    func getTranIds(filteredTransactions: [JoinedTransaction]) -> [Int] {
        return filteredTransactions.map {
            $0.transaction.id
        }
    }
    
    func getSum(filteredTransactions: [JoinedTransaction]) -> Double {
        return filteredTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
    }
    
    func getMaxTransaction(filteredTransactions: [JoinedTransaction]) -> JoinedTransaction? {
        guard let values = Aggregator(transactions: filteredTransactions).select(type: .max).group(by: .day).execute() else {
            return nil
        }
        
        return values.first?.transaction
    }
    
    func getAvgOf90Day() -> Double {
        let dateRanges = Date().getDateRanges(type: DateType.day(90))
        
        return self.transactions.filter {
            $0.transaction.spentDate >= dateRanges.from && $0.transaction.spentDate < dateRanges.to
            }.reduce(0, {$0 + $1.transaction.spentMoney}) / 90
    }
    
    func getContent91(content: Content) -> AnalysisResult? {
        
        //91    0    19    0    18    174    주간    이번주    어제는 평소보다 지출이 많았어요!        어제 지출은 %1$s이며, 주요 지출처는 ↵%2$s(%3$s)입니다.↵↵3개월 동안 하루 평균 지출은 %4$s입니다.     174,175,236,231    lv0_weekly_yesterday_muchspending    주간    어제지출-1    어제    1) 어제 지출 > (3개월 일평균지출X2)↵2) 이번달    어제는 평소보다 지출이 많았어요!    어제 지출은 32.1만원이며, 주요 지출처는 ↵아시아나항(31.1만원)입니다.↵↵3개월 동안 하루 평균 지출은 3.2만원입니다.     0    0    2018-07-22 14:45:22
        guard let dailySummary = self.dailySummary else {
            return nil
        }
        
        if dailySummary.sum > (dailySummary.dailyAvgOf12Week * 2) {
            
            guard let tran = dailySummary.maxTransaction else {
                return nil
            }
            
            let mContent = String(format: content.mediumContent,
                                  dailySummary.sum.toLv0Format(),
                                  tran.transaction.keyword,
                                  tran.transaction.spentMoney.toLv0Format(),
                                  dailySummary.dailyAvgOf12Week.toLv0Format())
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:content.largeContent,
                             mContent:mContent,
                             tranIds: dailySummary.tranIds))
        }
        
        return nil
        
    }
    
//    func getContent92(content: Content) -> Analysis? {
//
//        //    92    2    19    0    18    174    주간    이번주    어제 지출 %1$s    174    이번주 누적 지출은 %1$s입니다.↵↵3개월 동안 주간 평균 지출은 %2$s입니다.    232,230    lv0_weekly_yesterday_expenses    주간    어제지출-0    어제    1) 0 < 어제 지출 < (3개월 일평균지출X2)    어제 지출 116만원    이번주 누적 지출은 33.2만원입니다.↵↵3개월 동안 주간 평균 지출은 28.8만원입니다.    1    0    2018-07-22 14:45:44
//
//        guard let dailySummary = self.dailySummary else {
//            return nil
//        }
//        let avgOflast12Week = self.avgOfLast12Week ?? 0
//
//        if dailySummary.sum > 0 && dailySummary.sum < dailySummary.dailyAvgOf12Week * 2  {
//
//            let lContent = String(format: content.largeContent, dailySummary.sum.toLv0Format())
//
//            let mContent = String(format: content.mediumContent,
//                                  weeklys[0].sum.toLv0Format(),
//                                  avgOflast12Week.toLv0Format())
//
//            return Analysis((id:content.id,
//                             categoryPriority:content.categoryPriority,
//                             image:content.image,
//                             label:content.label,
//                             lContent:lContent,
//                             mContent:mContent,
//                             tranIds: dailySummary.tranIds))
//        }
//
//        return nil
//
//    }
    
}
