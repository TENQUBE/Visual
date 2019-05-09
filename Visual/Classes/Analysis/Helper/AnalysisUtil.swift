//
//  AnalysisUtil.swift
//  Visual
//
//  Created by tenqube on 12/03/2019.
//

import Foundation

class AnalysisUtil {
    
    static let sharedInstance = AnalysisUtil()
    
    private init() {
     
    }
    
    func getCardTypeStr(results: [AnalysisValue]) -> String {
   
        // 체크카드 22만원, 현금 3만원
        var sumByCardStr = [String]()
        
        for card in results {

            guard let tran = card.transaction else {
                continue
            }
            
            if CardType.check.rawValue == tran.card.changeType {
                sumByCardStr.append(CardType.check.content + " " + card.amount.toLv0Format())
            } else if CardType.cash.rawValue == tran.card.changeType {
                sumByCardStr.append(CardType.cash.content + " " + card.amount.toLv0Format())
            }
        }
        
        return sumByCardStr.joined(separator: Constants.Separator.comma.rawValue)
    }
    
    func getMediumStr(results: [AnalysisValue]) -> String {
        
        // 1위 커피 (22만원),\n
        var sumByMedium = [String]()
        
        for (i, medium) in results.enumerated() {
            
            if(i == 3) {
                break
            }
            
            guard let tran = medium.transaction else {
                continue
            }
            
            sumByMedium.append( "\(i + 1)위 \(tran.category.medium) (\(medium.amount.toLv0Format()))")
        }
        return sumByMedium.joined(separator: Constants.Separator.newLineComma.rawValue)
    }
    
    func getLargePercentStr(results: [AnalysisValue], sum: Double) -> String {
    
        // 주로 지출한 항목은↵↵1위 외식 (32%),↵2위 카페/간식 (22%), ↵3위 인터넷쇼핑 (21%) 입니다.
        
        var mList = [String]()
        for (i, result) in results.enumerated() {
            
            if(i == 3) {
                break
            }
            guard let tran = result.transaction else {
                continue
            }
            
            mList.append("\(i+1)위 \(tran.category.large) (\((result.amount * 100 / sum).toPercent()))")
          
        }
        return mList.joined(separator: Constants.Separator.newLineComma.rawValue)
        
    }
    
    func getLargePercentStr(results: [AnalysisValue], sum: Double) -> String {
        
        // 주로 지출한 항목은↵↵1위 외식 (32%),↵2위 카페/간식 (22%), ↵3위 인터넷쇼핑 (21%) 입니다.
        
        var mList = [String]()
        for (i, result) in results.enumerated() {
            
            if(i == 3) {
                break
            }
            guard let tran = result.transaction else {
                continue
            }
            
            mList.append("\(i+1)위 \(tran.category.large) (\((result.amount * 100 / sum).toPercent()))")
            
        }
        return mList.joined(separator: Constants.Separator.newLineComma.rawValue)
        
    }
    
    func getMediumStrWithPercent(results: [AnalysisValue], sum: Double) -> String {
        
        // 1위 아울렛 (31.2만원, 32%)↵2위 의류 (32.1만원, 32%)
        var sumByMedium = [String]()
        
        for (i, medium) in results.enumerated() {
            
            if(i == 3) {
                break
            }
            
            guard let tran = medium.transaction else {
                continue
            }
           
            let percent = medium.amount * 100 / sum
            sumByMedium.append( "\(i + 1)위 \(tran.category.medium) (\(medium.amount.toLv0Format()), \(percent.toPercent()))")
        }
        
        return sumByMedium.joined(separator: Constants.Separator.newLineComma.rawValue)
    }
    
    func getMediumCntStrWithPercent(results: [AnalysisValue], cnt: Int) -> String {
        
        //  맥도날드 5회,  KFC2회,↵광광광 1회
        var cntByMedium = [String]()
        
        for (i, medium) in results.enumerated() {
            
            if i == 3 {
                break
            }
            
            guard let tran = medium.transaction else {
                continue
            }
            
            cntByMedium.append( "\(tran.transaction.keyword) (\(medium.amount.toNumberformat())회)")
        }
        
        return cntByMedium.joined(separator: Constants.Separator.newLineComma.rawValue)
    }
    
    func getLargeImage(lcode: Int) -> String {
        
        guard let large = CategoryType(rawValue: lcode) else {
            return "lv0_mid_beauty_skin"
        }
        
        return large.imgs[Int.random(in: 0 ..< large.imgs.count)]
        
    }
    
    func getMediumImage(lcode: String, mcode: String) -> String {
    
        let lmcode = lcode + mcode
    
        switch (lmcode) {
            
        case "6613":
            return "lv0_mid_travel_hotel"
            
        case "6614":
            return "lv0_mid_travel_sightseeing"
            
        case "6212":
            return "lv0_mid_transportation_gas"
            
        case "6216":
            return "lv0_mid_transportation_taxi"
            
        case "6213":
            return "lv0_mid_transportation_car"
            
        case "6214":
            return "lv0_mid_transportation_masstransit"
            
        case "5611":
            return "lv0_mid_culture_movies"
            
        case "5612":
            return "lv0_mid_culture_books"
            
        case "5615":
            return "lv0_mid_culture_hobby"
            
        case "5411":
            return "lv0_mid_education_academy"
            
        case "5414":
            return "lv0_mid_education_school"
            
        case "5211":
            return "lv0_mid_livings_telecom"
            
        case "4614":
            return "lv0_mid_beauty_nail"
            
        case "4611":
            return "lv0_mid_beauty_hairshop"
            
        case "4612":
            return "lv0_mid_beauty_skin"
            
        case "4610":
            
            return "lv0_mid_beauty_makeup"
            
        case "4413":
            
            return "lv0_mid_healthcare_clinic"
            
        case "4412":
            return "lv0_mid_healthcare_dentist"
            
        case "4416":
            return "lv0_mid_healthcare_healthproduct"
            
        case "4414":
            return "lv0_mid_healthcare_pharmacy"
            
        case "4212":
            return "lv0_mid_finance_insurance"
            
        case "4211":
            return "lv0_mid_finance_tax"
            
        case "3614":
            return "lv0_mid_shopping_sportbrand"
            
        case "3411":
            return "lv0_mid_online_homeshop"
            
        case "3216":
            return "lv0_mid_mart_grocery"
            
        case "3211":
            return "lv0_mid_mart_conveni"
            
        case "3213":
            return "lv0_mid_mart_dailyitems"
            
        case "3217":
            return "lv0_mid_mart_events_flower"
            
        case "3212":
            return "lv0_mid_mart_housework"
            
        case "3214":
            return "lv0_mid_mart_kids_1"
            
        case "3215":
            return "lv0_mid_mart_pets"
            
        case "2613":
            return "lv0_mid_alcohol_soolzip"
            
        case "2611":
            return "lv0_mid_alcohol_entertainment"
            
        case "2414":
            return "lv0_mid_cafe_bakery"
            
        case "2411":
            return "lv0_mid_cafe_coffee"
            
        case "2415":
            return "lv0_mid_cafe_dessert"
            
        case "2416":
            return "lv0_mid_cafe_donut"
            
        case "2215":
            return "lv0_mid_food_chinese"
        case "2217":
            return "lv0_mid_food_dining_place"
        case "2213":
            return "lv0_mid_food_fam_re"
        case "2212":
            return "lv0_mid_food_fastfood_1"
        case "2222":
            return "lv0_mid_food_gogi"
        case "2216":
            return "lv0_mid_food_japanese"
            
        case "2211":
            return "lv0_mid_food_korean"
        case "2224":
            return "lv0_mid_food_late_night"
        case "2218":
            return "lv0_mid_food_western"
            
        case "2214":
            return "lv0_mid_chicken"
            
        default:
        
            guard let lcode = Int(lcode) else {
                return "lv0_mid_beauty_skin"
            }
            
            return getLargeImage(lcode: lcode)
        }
    }
    
}
