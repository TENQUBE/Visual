//
//  Advertisement.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation
public struct AnalysisResult: DataProtocol, Codable {
 
    let id: Int
    let categoryPriority: Int
    let image: String
    let label: String
    let lContent: String
    let mContent: String
    let tranIds: [Int]
    
    init(_ param: AnalysisParams) {
     
        self.id = param.id
        self.categoryPriority = param.categoryPriority
        self.image = param.image
        self.label = param.label
        self.lContent = param.lContent
        self.mContent = param.mContent
        self.tranIds = param.tranIds
        
    }
    
    func checkParams() throws {
        
    }
}



