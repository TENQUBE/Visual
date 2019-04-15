
class Weekly: VisualAnalysis {
  
    var weeklys = [WeeklySummary]()

    var avgOflast12Week: Double?
    
    var dayOfWeek: Int?
    
    override init(contents: [Content], transactions: [JoinedTransaction]) {
        super.init(contents: contents, transactions: transactions)
        
        // 이번주 내역
        self.weeklys.append(makeWeekSummary(before: 0))
        
        // 지난주 내역
        self.weeklys.append(makeWeekSummary(before: 1))

        // 지난 12주 1주 평균 지출
        self.avgOflast12Week = self.getAvgOfLast12Wek()
        
        // 주
        self.dayOfWeek = Date().getValue(componet: .weekday)
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = [AnalysisResult]()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 61:
                analysis = self.getContent61(content: content)
                break
            case 143:
                analysis = self.getContent143(content: content)
                break
            case 145:
                analysis = self.getContent145(content: content)
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
    
    public func getAvgOfLast12Wek() -> Double {
        let from = Date().getDateRanges(type: DateType.week(13)).0
        let to = Date().getDateRanges(type: DateType.week(1)).1
        
        let sum = self.transactions.filter {
            $0.transaction.spentDate >= from && $0.transaction.spentDate < to
            }.reduce(0, {$0 + $1.transaction.spentMoney})
        
        let avg  = sum / 12
        
        return avg
        
    }
    
    func makeWeekSummary(before: Int) -> WeeklySummary {
        let dateRanges = Date().getDateRanges(type: DateType.week(before))
        
        let filteredTransactions = transactions.filter {
            $0.transaction.spentDate >= dateRanges.from && $0.transaction.spentDate < dateRanges.to
        }
        
        let tranIds = filteredTransactions.map {
            $0.transaction.id
        }
        
        let sum = filteredTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
        
        return WeeklySummary(sum: sum, tranIds: tranIds)
    }
    
    func getContent61(content: Content) -> AnalysisResult? {
        //61    2    19    0    18    233    주간    지난주    지난주, 평소보다 ↵%1$s 많이 지출했습니다.    234    지난 3개월 동안 ↵평균적으로 1주일에 %1$s 썼습니다.↵지난주에는 %2$s (+%3$s)썼습니다.    230,233,234    lv0_weekly_summary    주간    요약    지난 주    1) 3개월의 1주일 평균 지출 * 1.2 < 지난주 지출↵2) 오늘 = 월화    지난주, 평소보다 ↵12% 많이 썼습니다.    지난 3개월 동안 ↵평균적으로 1주일에 30.1만원 썼습니다.↵지난주에는 32.6만원 (+12%)썼습니다.    1    0    2018-07-22 14:43:29
        let avgOfLast12Week = self.avgOflast12Week ?? 0
        
        if(avgOfLast12Week > 0) {
            let weeklySummary = weeklys[1]
            //        let dayCondition = self.dayOfWeek == 2 || self.dayOfWeek == 3)
            if (avgOfLast12Week * 1.12 < weeklySummary.sum ) {
                let percent = calculator.getPercentValue(first: weeklySummary.sum, divider: avgOfLast12Week)
                
                let lContent = String(format: content.largeContent, percent.toPercent())
                
                let mContent = String(format: content.mediumContent,
                                      avgOfLast12Week.toLv0Format(),
                                      weeklySummary.sum.toLv0Format(),
                                      percent.toPercent())
                
                return AnalysisResult((id:content.id,
                                       categoryPriority:content.categoryPriority,
                                       image:content.image,
                                       label:content.label,
                                       lContent:lContent,
                                       mContent:mContent,
                                       tranIds: weeklySummary.tranIds))
            }
        }
        
        return nil
    }
    
    func getContent143(content: Content) -> AnalysisResult? {
        
        //    143    2    21    0    2    233    주간    지난주    지난주 지출은 %1$s 입니다.    233    지난 12주 동안\n주간 평균 지출은 %1$s 입니다.    230    lv0_weekly_summary    주간    지난주 요약    지난주    1) 지난주 금액 > 0    지난주 지출은 22만원 입니다.    지난 12주 동안\n주간 평균 지출은22만원 입니다.    1    3    2018-09-13 04:46:25
        let weeklySummary = weeklys[1]
        
        let avgOfLast12Week = self.avgOflast12Week ?? 0
        
        if avgOfLast12Week > 0 && weeklySummary.sum > 0 {
            
            let lContent = String(format: content.largeContent, weeklySummary.sum.toLv0Format())
            
            let mContent = String(format: content.mediumContent,
                                  avgOfLast12Week.toLv0Format())
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:lContent,
                             mContent:mContent,
                             tranIds: weeklySummary.tranIds))
        }
        
        return nil

    }
    
    func getContent145(content: Content) -> AnalysisResult? {
 
        //    145    2    21    0    2    232    주간    이번주    이번 주 지출은 %1$s 입니다.    232    지난 12주 동안\n주간 평균 지출은 %1$s 입니다.    230    lv0_weekly_summary    주간    이번주 요약    이번주    이번주 금액 > 0    이번 주 지출은 22만원 입니다.    지난 12주 동안\n주간 평균 지출은22만원 입니다.    1    3    2018-09-13 04:46:27

        let weeklySummary = weeklys[0]
        
        let avgOfLast12Week = self.avgOflast12Week ?? 0
        
        if avgOfLast12Week > 0 && weeklySummary.sum > 0 {
            
            let lContent = String(format: content.largeContent, weeklySummary.sum.toLv0Format())
            
            let mContent = String(format: content.mediumContent,
                                  avgOfLast12Week.toLv0Format())
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:lContent,
                             mContent:mContent,
                             tranIds: weeklySummary.tranIds))
        }
        
        return nil

    }

}
