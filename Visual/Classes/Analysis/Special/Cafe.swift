//
//  File.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

class Cafe : CommonCategory{
  
    let coffeeCode = "11"
    
    var summary: CafeSummary?
    
    override init(contents: [Content],
                  transactions: [JoinedTransaction],
                  categoryType: CategoryType) {
        
        super.init(contents: contents, transactions: transactions, categoryType: categoryType)
        
        summary = self.makeSummary()
    }
    
    override func getContents() -> [AnalysisResult] {
        
        var analysies = super.getContents()
        for content in contents {
            
            var analysis: AnalysisResult?
            switch (content.id) {
            case 25:
                analysis = self.getContent25(content: content)
                break
            case 26:
                analysis = self.getContent26(content: content)
                break
            case 30:
                analysis = self.getContent30(content: content)
                break
            case 139:
                analysis = self.getContent139(content: content)
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
    
    func makeSummary() -> CafeSummary {
        
        // 월별
        let months = self.getMonths()
        
        // 커피타입, 커피 타입 예시
        // 일주일에 카페 몇회 지난 3개월
        
        let cnt = Double(months.reduce(0, {$0 + $1.cnt}))
        
        let threeMonthDays = Double(calculator.threeMonthDays)
        
        let onceAweek = threeMonthDays == 0 ? 0.0 : Double(cnt) * 7 / Double(threeMonthDays);
        
        let coffeeTypes = self.getCoffeeCountry(weekAvg: onceAweek)
        let coffeeType = coffeeTypes.0
        let coffeeTypeEx = coffeeTypes.1
        
        let cntOfThreeMonth = months.reduce(0, {$0 + $1.cnt})
        
        // 지난 3개월 커피지출 합
        let sumOfThreeMonth = months.reduce(0, {$0 + $1.sum})
    
        // 지난 3개월 모닝커피 지출 합
        let sumOfMorning = calculator.getMorningSum(filteredTransactions: self.transactions)
        
        // 이번달 커피 맥스 날짜
        let maxDate = getMaxCoffeeDate()
        
        
        return CafeSummary(months: months,
                           coffeeType: coffeeType,
                           coffeeTypeEx: coffeeTypeEx,
                           onceAweek: onceAweek,
                           cntOfThreeMonth: cntOfThreeMonth,
                           sumOfThreeMonth: sumOfThreeMonth,
                           sumOfMorning: sumOfMorning,
                           maxDate: maxDate)
    }
    
    func getMonths() -> [Coffee] {
        
        var months = [Coffee]()
        for i in 0..<4 {
            let dateRanges = Date().getDateRanges(type: DateType.month(i))
            
            let month = dateRanges.from.getValue(componet: .month)
            
            let filteredTransactions = filterTransactions(transactions: filterTransactions(from: dateRanges.from, to: dateRanges.to),
                                                          mcode: coffeeCode)
            
            let cnt = filteredTransactions.count
            
            let sum = filteredTransactions.reduce(0, {$0 + $1.transaction.spentMoney})
            
            let tranIds = filteredTransactions.map {
                $0.transaction.id
            }
            
            months.append((month: month, cnt: cnt, sum: sum, tranIds: tranIds))
        }
        return months
    }
    
    func getCoffeeCountry(weekAvg: Double) ->(String, String) {
        if (23.0 < weekAvg) {
            return ("노르웨이", "25잔/1주일")
        } else if (20.0 < weekAvg && weekAvg <= 23.0) {
            return ("스위스", "22잔/1주일")
        } else if (17.0 < weekAvg && weekAvg <= 20.0) {
            return ("캐나다", "19잔/1주일")
        } else if (14.0 < weekAvg && weekAvg <= 17.0) {
            return ("브라질", "16잔/1주일")
        } else if (11.8 < weekAvg && weekAvg <= 14.0) {
            return ("미국", "13잔/1주일")
        } else if (8.5 < weekAvg && weekAvg <= 11.8) {
            return ("일본", "11잔/1주일")
        } else if (5.5 < weekAvg && weekAvg <= 8.5) {
            return ("한국", "6잔/1주일")
        } else if (3.0 < weekAvg && weekAvg <= 5.5) {
            return ("러시아", "5잔/1주일")
        } else if (2.2 < weekAvg && weekAvg <= 3.0) {
            return ("태국", "3잔/1주일")
        } else if (0.97 < weekAvg && weekAvg <= 2.2) {
            return ("이집트", "2잔/1주일")
        } else {
            return ("인도", "1잔 이하/1주일")
        }
    }
    
    func getMaxCoffeeDate() -> String? {
        let dateRanges = Date().getDateRanges(type: DateType.month(0))
        
      
        let transactions = filterTransactions(transactions: filterTransactions(from: dateRanges.from, to: dateRanges.to),
                                              mcode: coffeeCode)
        
        return Aggregator(transactions: transactions).select(type: AggregateType.sum).group(by: .day).execute()?.first?.transaction?.transaction.spentDate.toMDStr()
        
    }
    
    func getContent25(content: Content) -> AnalysisResult? {
        //    25    2    1    0    24    133    카페/간식    지난3개월    일주일에 카페 %1$s회    216    지난 3개월간 커피 지출은 %1$s건입니다.↵이는 %2$s인과 유사한 수준입니다.  ↵(%3$s)↵    133,134,178    lv0_cafe_type_country    카페/간식    유형    1) 3개월,↵2) 커피    1) 중분류 커피 횟수>1    일주일에 카페 25회    지난 3개월간 커피 지출은 272건입니다.↵이는 노르웨이인과 유사한 수준입니다.  ↵(26잔/1주일)↵    1    0    2018-07-22 18:11:41
        guard let summary = self.summary else {
            return nil
        }
        
        if summary.cntOfThreeMonth > 1 {
            
            let lContent = String(format: content.largeContent, summary.onceAweek.toFirstDotFormat())
            
            let mContent = String(format: content.mediumContent, summary.cntOfThreeMonth.toNumberformat(),
                                  summary.coffeeType,
                                  summary.coffeeTypeEx)
            
            let tranIds = summary.months.flatMap {
                $0.tranIds
            }
            
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
    
    func getContent26(content: Content) -> AnalysisResult? {
        //    26    2    1    0    24    177    카페/간식    지난3개월    모닝 커피를↵직접 내려 마셨다면...        커피 지출을 %1$s 정도 절약할 수 있습니다. ↵↵지난 3개월 커피 지출 %2$s 중 %3$s이↵모닝 커피 지출입니다.    177,130,177    lv0_cafe_coffee_morning    카페/간식    절약    1) 3개월↵2) 커피    1) 3개월 아침 커피 금액>3만원    모닝 커피를↵직접 내려 마셨다면...    커피 지출을 12.1만원 정도 절약할 수 있습니다. ↵↵지난 3개월 커피 지출 35.2만원 중 12.1만원이↵모닝 커피 지출입니다.    1    0    2018-07-22 14:38:48
        guard let summary = self.summary else {
            return nil
        }
        
        if summary.sumOfMorning.sum > 30000 {
            
            let diff = summary.sumOfThreeMonth - summary.sumOfMorning.sum
            
            let mContent = String(format: content.mediumContent, diff.toLv0Format(),
                                  summary.sumOfThreeMonth.toLv0Format(),
                                  summary.sumOfMorning.sum.toLv0Format())
            

            
            return AnalysisResult((id:content.id,
                             categoryPriority:content.categoryPriority,
                             image:content.image,
                             label:content.label,
                             lContent:content.largeContent,
                             mContent:mContent,
                             tranIds: summary.sumOfMorning.tranIds))
        }
        
        return nil
        
    }
    
    func getContent30(content: Content) -> AnalysisResult? {
        //    30    2    1    0    24    55    카페/간식    지난달    지난 달 커피 지출은↵%1$s입니다.    55    %1$s월 %2$s,↵%3$s월 %4$s↵%5$s월 %6$s으로↵↵3개월 동안 커피 지출은 %7$s 입니다.    28,55,69,96,99,126,130    lv0_mid_cafe_coffee    카페/간식    지난달_커피    1) 지난 달,↵2) 커피    1) 지난 달 커피 값 > 4만원,↵2) 날짜 : 20일 이전    지난 달 커피 지출은↵10.2만원입니다.    7월 10.2만원,↵6월 15.2만원↵5월 2.1만원으로↵↵3개월 동안 커피 지출은 111.1만원 입니다.    1    0    2018-07-22 14:40:15
        guard let summary = self.summary else{
            return nil
        }
        
        if summary.months[1].sum > 40000 &&
            calculator.today <= 20 {
            
            let lContent = String(format: content.largeContent, summary.months[1].sum.toLv0Format())
            
            
            let mContent = String(format: content.mediumContent,
                                  summary.months[1].month.toStr(), summary.months[1].sum.toLv0Format(),
                                  summary.months[2].month.toStr(), summary.months[2].sum.toLv0Format(),
                                  summary.months[3].month.toStr(), summary.months[3].sum.toLv0Format(),
                                  summary.sumOfThreeMonth.toLv0Format())
            
            let tranIds = summary.months[1].tranIds
            
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
    
    func getContent139(content: Content) -> AnalysisResult? {
        //139    2    1    0    24    207    카페/간식    이번달    이번 달 커피 지출은\n%1$s 입니다.    207    이번 달 커피 지출은 총 %1$s 였으며,\n커피값이 가장 많이 나간 날은\n%2$s 입니다.    267,266    lv0_mid_cafe_coffee    카페/간식    이번달 커피    이번달    이번달 커피 > 10000    이번 달 커피 지출은\n%10만원 입니다.    이번 달 커피 지출은 총 % 2회 였으며,\n커피값이 가장 많이 나간 날은\n02월 03일 입니다.    1    3    2018-09-13 05:28:47

        guard let summary = self.summary, let maxDate = summary.maxDate else {
            return nil
        }
        
        if summary.months[0].sum > 10000 {
            
            let lContent = String(format: content.largeContent, summary.months[0].sum.toLv0Format())
            
            let mContent = String(format: content.mediumContent, summary.months[0].cnt.toNumberformat(), maxDate)
            
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

}
