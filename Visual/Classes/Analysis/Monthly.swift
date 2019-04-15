//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation

class Monthly: VisualAnalysis {
    
    var months: [MonthSummary] = []
    var threeMonth: MonthSummary?
    
    var samePeriodMonths: [MonthSummary] = []
    
    override init(contents: [Content], transactions: [JoinedTransaction]) {
        super.init(contents: contents, transactions: transactions)
    
        self.setMonths()

        self.setSamePeroid()

        self.setLastThreeMonth()

    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = [AnalysisResult]()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 49:
                analysis = self.getContent49(content: content)
                break
            case 51:
                analysis = self.getContent51(content: content)
                break
            case 52:
                analysis = self.getContent52(content: content)
                break
            case 54:
                analysis = self.getContent54(content: content)
                break
            case 55:
                analysis = self.getContent55(content: content)
                break
            case 75:
                analysis = self.getContent75(content: content)
                break
            case 76:
                analysis = self.getContent76(content: content)
                break
            case 77:
                analysis = self.getContent77(content: content)
                break
            case 80:
                analysis = self.getContent80(content: content)
                break
            case 102:
                analysis = self.getContent102(content: content)
                break
            case 103:
                analysis = self.getContent103(content: content)
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
    
    func setMonths() {
        for i in 0..<4 {
            
            let dateRanges = Date().getDateRanges(type: DateType.month(i))
            
            let month = dateRanges.from.getValue(componet: .month)
            let filteredTransactions = transactions.filter {
                $0.transaction.spentDate >= dateRanges.from && $0.transaction.spentDate < dateRanges.to
            }
            
            let sum = Aggregator(transactions: filteredTransactions)
                .select(type: AggregateType.sum)
                .group(by: GroupByType.month)
                .executeForDict().values.first ?? AnalysisValue(key: "", amount: 0, tranIds: [], transaction: nil)
            
            
            let sumByCard = Aggregator(transactions: filteredTransactions)
                .select(type: AggregateType.sum)
                .group(by: GroupByType.cardType)
                .executeForDict()
            
            let sumByCategory = Aggregator(transactions: filteredTransactions)
                .select(type: AggregateType.sum)
                .group(by: GroupByType.largeCategory)
                .executeForDict()
            
            let monthSummary = MonthSummary(monthStr: month.toStr(), sum: sum.amount, tranIds: sum.tranIds, sumByCard: sumByCard, sumByCategory: sumByCategory, transactions: filteredTransactions)
            
            self.months.append(monthSummary)
            
        }
    }
    
    func setSamePeroid() {
        guard let today = Date().addDay(day: 1) else {
            return
        }
        
        for i in 0..<2 {
            
            let dateRanges = Date().getDateRanges(type: DateType.month(i))
            
            let month = dateRanges.from.getValue(componet: .month)
            
            guard let endDate = i == 0 ? today :today.getNthMonth(nth: -1) else {
                return
            }
            
            let filteredTransactions = transactions.filter {
                $0.transaction.spentDate >= dateRanges.from && $0.transaction.spentDate < endDate
            }
            
            let sum = Aggregator(transactions: filteredTransactions)
                .select(type: AggregateType.sum)
                .group(by: GroupByType.month)
                .executeForDict().values.first ?? AnalysisValue(key: "", amount: 0, tranIds: [], transaction: nil)
            
            let sumByCategory = Aggregator(transactions: filteredTransactions)
                .select(type: AggregateType.sum)
                .group(by: GroupByType.largeCategory)
                .executeForDict()
            
            
            let monthSummary = MonthSummary(monthStr: month.toStr(), sum: sum.amount, tranIds: sum.tranIds, sumByCard: [:], sumByCategory: sumByCategory, transactions: filteredTransactions)
            
            self.samePeriodMonths.append(monthSummary)
            
        }
        
    }
    
    func setLastThreeMonth() {
        var monthList = [String]()
        var sum: Double = 0
        var tranids = [Int]()
        var sumByCard = [String: AnalysisValue]()
        var sumByCategory = [String: AnalysisValue]()
        var filteredTransactions = [JoinedTransaction]()
        
        for i in 1..<4 {
            let month = self.months[i]
            monthList.append(month.getMonthStr())
            
            sum += month.sum
            tranids += month.tranIds
            
          
            sumByCard.merge(dict: month.sumByCard)
            sumByCategory.merge(dict: month.sumByCategory)

            filteredTransactions += month.transactions
        }
        
       
        let monthStr = "(\(monthList.reversed().joined(separator: ",")))"
        self.threeMonth = MonthSummary(monthStr: monthStr,
                                       sum: sum,
                                       tranIds: tranids,
                                       sumByCard: sumByCard,
                                       sumByCategory: sumByCategory,
                                       transactions: filteredTransactions)
        
        self.threeMonth?.avg = sum / 3
       
    }
    
    func getContent51(content: Content) -> AnalysisResult? {
   
//        51    2    20    0    11    5    월간    이번달    이번 달 신용카드 사용금액은↵%1$s입니다.    5    체크카드 %1$s으로 ↵%2$s월 총 지출은 %3$s입니다.     6,1,2    lv0_monthly_card_3month    월간    신용카드 (이번달 금액)    이번 달    1) 신용카드 사용금액 >20만원, 체크>0    이번 달 신용카드 사용금액은↵101.2만원입니다.    체크카드 0.2만원, 현금 0.0만원으로 ↵4월 총 지출은 136.3만원입니다.     1    0    2018-07-22 14:43:00
        return getCardType(content: content, summary: months[0], dateType: DateType.month(0))
    }
    
    func getContent52(content: Content) -> AnalysisResult? {
        
        //    52    2    20    0    11    33    월간    지난달    지난달 신용카드 사용금액은\n%1$s입니다.    33    체크카드 %1$s으로 \n%2$s월 총 지출은 %3$s입니다.     34,28,29    lv0_monthly_card_3month    월간    신용카드 (지난달 금액)    지난 달    1) 신용카드 사용금액 >20만원,체크>0    지난 달 신용카드 사용금액은↵101.2만원입니다.    체크카드 0.2만원, 현금 0.0만원으로 ↵4월 총 지출은 136.3만원입니다.     1    0    2018-09-12 05:43:32
        return getCardType(content: content, summary: months[1], dateType: DateType.month(1))
    }
    
    func getContent49(content: Content) -> AnalysisResult? {
        
        guard let threeMonth = self.threeMonth else {
            return nil
        }
        //    49    2    20    0    11    247    월간    지난3개월    지난 3개월 신용카드 결제 금액은\n%1$s 입니다.    247    %1$s으로\n%2$s 총지출은 %3$s 입니다.    249,248,224    lv0_monthly_card_3month    월간    지난3개월 신용카드    지난 3개월    지난 3개월 금액합 > 0, 2) 신용카드 금액합 > 1000000    지난 3개월 신용카드 결제 금액은\n23만원 입니다.    체크카드 22만원, 현금 3만원으로\n(1월, 2월, 3월) 총지출은 33만원 입니다.    1    3    2018-09-13 04:46:48
        
        return getCardType(content: content, summary: threeMonth, dateType: .lastThreeMonth)
    }
    
    func getCardType(content: Content, summary: MonthSummary, dateType: DateType) -> AnalysisResult? {
        
        if(summary.sum > 0 && summary.getCardList().count > 1) {
            var results = summary.getCardList()
            
            
            guard let credit = results.first(where: {$0.key == CardType.credit.rawValue.toStr()}) else {
                return nil
            }
            
            results.removeAll(where: {$0.key == CardType.credit.rawValue.toStr()})
            
            
            let lContent = String(format: content.largeContent, credit.amount.toLv0Format())
            
            var mContent = ""
            switch(dateType) {
            case .lastThreeMonth:
                let sumBytypeStr = analysisUtil.getCardTypeStr(results: results)
                
                mContent = String(format: content.mediumContent, sumBytypeStr, summary.monthStr, summary.sum.toLv0Format())
                
                break
            default:
                guard let check = results.first(where: {$0.key == CardType.check.rawValue.toStr()}) else {
                    return nil
                }
                
                mContent = String(format: content.mediumContent, check.amount.toLv0Format(), summary.monthStr, summary.sum.toLv0Format())
                break

            }
         
            let tranIds = credit.tranIds
            
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
    
    func getContent54(content: Content) -> AnalysisResult? {
        
        //    54    2    20    0    11    243    월간    이번달    이번 달 최대 지출일은 \n%1$s 입니다.    243    이날 최대 지출 내역은\n%1$s 입니다.    244    lv0_monthly_large_date    월간    최대지출    이번달    최대지출일 지출 > 월 누적 지출 *0.1    이번 달 최대 지출일은 \n2018-09-01 입니다.    이날 최대 지출 내역은\n 노래방(2.2만원) 입니다.    1    3    2018-09-13 04:46:50
        return getMaxSpendByDay(content: content, summary: months[0])
    }
    
    func getContent55(content: Content) -> AnalysisResult? {
        //    55    2    20    0    11    245    월간    지난달    지난달 최대 지출일은\n%1$s 입니다.    245    이날 최대 지출 내역은\n%1$s 입니다.    246    lv0_monthly_large_date    월간    지난달 최대지출    지난달    1) 최대지출일 지출 > 월 누적 지출 *0.1    지난달 최대 지출일은\n2018-09-10입니다.    이날 최대 지출 내역은\n농협 (23만원) 입니다.    1    3    2018-09-13 04:46:52
        
        return getMaxSpendByDay(content: content, summary: months[1])
    }
    
    func getMaxSpendByDay(content: Content, summary: MonthSummary) -> AnalysisResult? {
        
        guard let results = Aggregator(transactions: summary.transactions)
            .select(type: AggregateType.sum)
            .group(by: GroupByType.day)
            .execute(),
            let transaction = results[0].transaction else {
                return nil
        }
        
       
        let maxOfDay = results.first!.amount
        if(maxOfDay > summary.sum * 0.1) {
        
            let maxDate = transaction.transaction.spentDate.toDayStr()
            
            let maxValue = summary.transactions.filter {
                $0.transaction.spentDate.toDayStr() == maxDate
                }.max {
                    $0.transaction.spentMoney < $1.transaction.spentMoney
            }
            
            let keyword = maxValue!.transaction.keyword
            let spentMoney = maxValue!.transaction.spentMoney
        
       
            let transactionStr = "\(String(describing: keyword))(\(String(describing: spentMoney.toLv0Format())))"
            
            let lContent = String(format: content.largeContent, maxDate)
            
            let mContent = String(format: content.mediumContent, transactionStr)
            
            let tranIds = results[0].tranIds
            
            return AnalysisResult((id:content.id,
                                   categoryPriority: content.categoryPriority,
                                   image: content.image,
                                   label: content.label,
                                   lContent:lContent,
                                   mContent:mContent,
                                   tranIds: tranIds))
        } else {
            return nil
        }
    }
    
    func getContent75(content: Content) -> AnalysisResult? {

        guard let threeMonth = self.threeMonth else {
            return nil
        }
        
        if months[1].sum > 0 &&
            months[2].sum > 0 &&
            months[3].sum > 0 {
            
            //    75    2    20    0    11    224    월간    지난3개월    지난 3개월,\n%1$s 지출했습니다.    224    %1$s월 %2$s, \n%3$s월 %4$s, \n%5$s월 %6$s 사용하여\n\n한 달 평균 지출은 %7$s입니다.    99,100,69,70,28,29,214    lv0_monthly_report    월간    요약 (3개월 금액)    3개월    1) 지난 3개월 각각 >0원    지난 3개월,↵321.2만원 썼습니다.    1월 126.2만원, ↵2월 121.3만원, ↵3월 121.2만원 사용하여↵↵한 달 평균 지출은 121.2만원입니다.    1    0    2018-09-12 05:43:32
            let lContent = String(format: content.largeContent, threeMonth.sum.toLv0Format())
            
            let mContent = String(format: content.mediumContent,
                                  months[3].monthStr, months[3].sum.toLv0Format(),
                                  months[2].monthStr, months[2].sum.toLv0Format(),
                                  months[1].monthStr, months[1].sum.toLv0Format(),
                                  threeMonth.avg.toLv0Format())
            
            let tranIds = threeMonth.tranIds
            
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
    
    func getContent77(content: Content) -> AnalysisResult? {
        //    77    2    20    0    11    29    월간    지난달    지난달 %1$s 지출했습니다.    29    주로 지출한 항목은\n\n%1$s 입니다.     242    lv0_monthly_report    월간    요약 (지난달)    지난 달    1) 지난 달 >0원  카테고리별 합, 1-3위 각각  >0원    지난 달 32.1만원 지출했습니다.    주로 지출한 항목은↵↵1위 외식 (32%),↵2위 카페/간식 (22%), ↵3위 인터넷쇼핑 (21%) 입니다.     1    1    2018-09-12 05:43:32
        // 지난달 카테고리별 탑3
        let summary = months[1]
   
        if summary.getCategoryList().count >= 3 &&
            summary.getCategoryList()[0].amount > 0 &&
            summary.getCategoryList()[1].amount > 0 &&
            summary.getCategoryList()[2].amount > 0
            
            {
                let lContent = String(format: content.largeContent, summary.sum.toLv0Format())
                
                let mValue = analysisUtil.getLargePercentStr(results: summary.getCardList(), sum: summary.sum)
                
                let mContent = String(format: content.mediumContent, mValue)
                
                return AnalysisResult((id:content.id,
                                       categoryPriority:content.categoryPriority,
                                       image:content.image,
                                       label:content.label,
                                       lContent:lContent,
                                       mContent:mContent,
                                       tranIds: summary.tranIds))
        }
        
        return nil
        
        
       
    }
    
    func getContent78(content: Content) -> AnalysisResult? {
  
        //    78    2    20    0    11    2    월간    이번달    이번 달은 평소보다\n지출이 많을 것 같습니다.        이번 달은 유난히 지출이 많은 것 같습니다.\n최근 지출 중 가장 큰 지출은\n%1$s 입니다.    244    lv0_monthly_summary_toomuch    월간    최대지출    이번달    1) 이번달 > 지난 3개월 평균 * 1.15    이번 달은 평소보다\n지출이 많을 것 같습니다.    이번 달은 유난히 지출이 많은 것 같습니다.\n최근 지출 중 가장 큰 지출은\n%스타벅스 (22만원) 입니다.    1    3    2018-09-13 06:07:52
        
        guard let threeMonth = self.threeMonth else {
            return nil
        }
        
        let summary = months[0]
        
        if summary.sum > threeMonth.avg * 1.15 {
            guard let month0Tran = Aggregator(transactions: summary.transactions)
                .select(type: AggregateType.max)
                .group(by: GroupByType.month)
                .execute() else {
                    return nil
            }
            
            if month0Tran.count == 0 {
                return nil
            }
            
            guard let maxTransaction = month0Tran[0].transaction else {
                return nil
            }
            
            let mContentValue = "\(maxTransaction.transaction.keyword) (\(maxTransaction.transaction.spentMoney.toLv0Format()))"
            let mContent = String(format: content.mediumContent, mContentValue)
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:content.largeContent,
                             mContent:mContent,
                             tranIds: summary.tranIds))
        }
        return nil
    }
    
    func getContent80(content: Content) -> AnalysisResult? { // 카테고리별 월별합
//    80    2    20    0    11    224    월간    지난3개월    한 달 평균 지출은\n%1$s 입니다.    214    항목별로 한 달에 쓰는 돈은\n%1$s 입니다.    252    lv0_monthly_top3    월간    지난3개월 평균    지난 3개월    지난 3개월 카테고리별 사용 > 2    한 달 평균 지출은\n22만원입니다.    항목별로 한 달에 쓰는 돈은\n1위 식사 (32%),\n2위 카페/간식(22%) 입니다.    1    3    2018-09-13 04:46:55

        guard let threeMonth = self.threeMonth else {
            return nil
        }
    
        if threeMonth.getCategoryList().count > 2 {
           
            let mValue = analysisUtil.getLargePercentStr(results: threeMonth.getCategoryList(), sum: threeMonth.sum)
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:String(format: content.largeContent, threeMonth.avg.toLv0Format()),
                             mContent:String(format: content.mediumContent, mValue),
                             tranIds: threeMonth.tranIds))
        }
        
        return nil

    }
    
    func getCAC(before: Int) -> [AnalysisValue?] {
        let summary = self.samePeriodMonths[before]
        
        let food = summary.sumByCategory[String(CategoryType.food.rawValue)]
        let cafe = summary.sumByCategory[String(CategoryType.cafe.rawValue)]
        let alcohol = summary.sumByCategory[String(CategoryType.alcohol.rawValue)]
        return [food, cafe, alcohol]
    }

    func getContent102(content: Content) -> AnalysisResult? {
        //    102    2    20    0    11    253    월간    이번달    먹고 마시는데 %1$s 썼습니다.    253    이번 달 지출의 %1$s를 차지하며\n지난달 같은 일자 대비 %2$s했습니다\n\n항목별로는 %3$s    254,255,256    lv0_monthly_eatanddrink_2    월간    먹고마시는데    이번달    2) 이번 달 외식, 술, 카페 중 2개 이상 >0원↵//                3) 지난 달 외식 + 술 + 카페 >0원    먹고 마시는데 22만원 썼습니다.    이번 달 지출의 20%를 차지하며\n지난달 같은 일자 대비 2% 증가했습니다\n\n항목별로는 식사 22%,\n 카페/간식 23%,\n 술/유흥 20% 입니다.    1    3    2018-09-13 04:46:57

        if self.months[0].sum > 0 && self.months[1].sum > 0 {
            
            let cac = getCAC(before: 0)
            
            let noneZeroCAC = cac.compactMap {_ in
                
            }
            if noneZeroCAC.count < 2 {
                return nil
            }
       
            let sum0: Double = cac.reduce(0, {$0 + ($1?.amount ?? 0)})
            
            let cac1 = getCAC(before: 1)
            let sum1: Double = cac.reduce(0, {$0 + ($1?.amount ?? 0)})

            let percent = sum0 * 100 / self.months[0].sum
            let percentOfSamePeriod = sum1 == 0 ? 100 : (sum0 - sum1) * 100 / sum1
            let samePeriodStr = percentOfSamePeriod > 0 ? "\(abs(percentOfSamePeriod).toPercent()) 증가" : "\(abs(percentOfSamePeriod).toPercent()) 감소";
        
            let foodSum0 = cac[0]?.amount ?? 0
            let cafeSum0 = cac[1]?.amount ?? 0
            let alcoholSum0 = cac[2]?.amount ?? 0

            let foodSum1 = cac1[0]?.amount ?? 0
            let cafeSum1 = cac1[1]?.amount ?? 0
            let alcoholSum1 = cac1[2]?.amount ?? 0

            
            let foodPercent = foodSum1 == 0 ? 100 :  calculator.getPercentValue(first:foodSum0, divider: foodSum1)
            let cafePercent = cafeSum1 == 0 ? 100 :  calculator.getPercentValue(first:cafeSum0, divider: cafeSum1)
            let alcoholPercent = alcoholSum1 == 0 ? 100 : calculator.getPercentValue(first:alcoholSum0, divider: alcoholSum1)
            
            let lContentValue = sum0.toLv0Format()
            let mContentValue = "식사 \(foodPercent.toPercent())\(Constants.Separator.newLineComma.rawValue)카페/간식 \(cafePercent.toPercent())\(Constants.Separator.newLineComma.rawValue)술/유흥 \(alcoholPercent.toPercent())"
            
            let tranIds = Array(cac.compactMap {
                $0?.tranIds
            }.joined())
        
            
            return AnalysisResult((id:content.id,
                                   categoryPriority:content.categoryPriority,
                                   image:content.image,
                                   label:content.label,
                                   lContent:String(format: content.largeContent, lContentValue),
                                   mContent:String(format: content.mediumContent, percent.toPercent(), samePeriodStr, mContentValue),
                                   tranIds: tranIds))
        }
        
        return nil
    }
    
    func getContent103(content: Content) -> AnalysisResult? {
     //    103    2    20    0    11    2    월간    이번달    어느 새 월말이 다가왔습니다.\n이번 달은 평소보다 %1$s 쓴 편입니다.    225    이번 달 지출은\n결제 %1$s건,  1회 평균 지출 %2$s,\n누적 지출 %3$s입니다.\n\n평소보다 %4$s 정도 %5$s 지출했습니다.    3,4,2,206,225    lv0_monthly_bills    월간    월말 - 요약    1개월    1) 20일 이후↵2) 사용금액 > 0원↵3) 지난달 금액 > 0원↵    어느 새 월말이 다가왔습니다.↵이번 달은 평소보다 %s이 쓴 편입니다.    이번 달 지출은↵결제 11건,  1회 평균 지출 35,000원,↵누적 지출 385,000원입니다.↵↵평소보다 12% 정도 많이 지출했습니다.    1    0    2018-09-12 05:43:32
        
        let day = Date().getValue(componet: .day)
        
        if day >= 20 {
            
            if samePeriodMonths[0].sum == 0 || samePeriodMonths[1].sum == 0 {
                return nil
            }
            
            let cnt = self.samePeriodMonths[0].transactions.count
            let sum = self.samePeriodMonths[0].sum
            let avg = cnt == 0 ? 0 : sum/Double(cnt)
            
            //        지난달보다\n%1$s %2$s 쓰고 있습니다.    206,225
            let percent = calculator.getPercentValue(first:samePeriodMonths[0].sum, divider: samePeriodMonths[1].sum)
            var percentStr = ""
            
            if percent > 0 {
                percentStr = "많이"
            } else {
                percentStr = "적게"
            }
            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent: String(format: content.largeContent, percentStr),
                             mContent:String(format: content.mediumContent, cnt.toNumberformat(), avg.toLv0Format(), sum.toLv0Format(),  abs(percent).toPercent(), percentStr),
                             tranIds: self.samePeriodMonths[0].tranIds))
        }
        
        return nil
    }
    
    func getContent76(content: Content) -> AnalysisResult? {
        
        //    76    2    20    0    11    2    월간    이번달    지난달보다\n%1$s %2$s 쓰고 있습니다.    206,225    지난달 %1$s일까지 %2$s 썼습니다.\n이번 달은 %3$s 썼습니다.    226,32,2    239    월간    요약 (이번달)    이번 달    1) 이번달, 지난 달 >0원    지난 달보다↵12% 적게 쓰고 있습니다.    지난 달 15일까지 312,000원 썼습니다.↵이번 달은 142,200원 썼습니다.    1    0    2018-09-12 05:43:32
        //월별 같은기간 금액합
        if samePeriodMonths[0].sum == 0 || samePeriodMonths[1].sum == 0 {
            return nil
        }
        
        var image = ""
        
        //        지난달보다\n%1$s %2$s 쓰고 있습니다.    206,225
        let percent = calculator.getPercentValue(first:samePeriodMonths[0].sum, divider: samePeriodMonths[1].sum)
        var percentStr = ""
        if percent > 0 {
            percentStr = "많이"
            image = "lv0_monthly_up"
        } else {
            percentStr = "적게"
            image = "lv0_monthly_down"
        }
        
        let lContent = String(format: content.largeContent, abs(percent).toPercent(), percentStr)
        
        //        지난달 %1$s일까지 %2$s 썼습니다.\n이번 달은 %3$s 썼습니다.
        guard let day = Date().getNthMonth(nth: -1)?.getValue(componet: .day) else {
            return nil
        }
        
        let mContent = String(format: content.mediumContent,
                              String(day),
                              samePeriodMonths[1].sum.toLv0Format(),
                              samePeriodMonths[0].sum.toLv0Format())
        
        
        return AnalysisResult((id:content.id,
                         categoryPriority:content.categoryPriority,
                         image:image,
                         label:content.label,
                         lContent:lContent,
                         mContent:mContent,
                         tranIds: samePeriodMonths[0].tranIds))
    }

}
