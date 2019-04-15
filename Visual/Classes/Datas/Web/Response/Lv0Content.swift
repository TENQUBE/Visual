//
//  Lv0Content.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
//{\"success\":[{\"id\":92,\"image\":\"lv0_weekly_yesterday_expenses\",\"lContent\":\"어제 지출 3.5만원\",\"label\":\"일간\",\"mContent\":\"이번 주 누적 지출은 81.5만원입니다.\\n\\n3개월 동안 주간 평균 지출은 76.1만원입니다.\",\"tranIds\":[371,372,373]}]}
struct Lv0Content: Codable {
    let success: [AnalysisResult]
    
    init(items: [AnalysisResult]) {
        self.success = items
    }
}

