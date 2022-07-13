//
//  VisualRepo.swift
//  Visual
//
//  Created by tenqube on 27/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol AnalysisRepo {
    
    func generateDatas(callback: @escaping (Bool) -> ())
    
    func loadAnalysisList(req: [JoinedTransaction], callback: @escaping ([AnalysisResult]) -> ())
    
    func clearCache();
}
