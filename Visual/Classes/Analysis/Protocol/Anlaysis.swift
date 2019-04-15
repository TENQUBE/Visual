//
//  AnalysisProtocol.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
protocol Analysis {
    
    func getContents() -> [AnalysisResult]
}
