//
//  AnalysisDataSource.swift
//  Visual
//
//  Created by tenqube on 06/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol AnalysisDataSource {
    
    func findAll() throws -> [AnalysisResult]
    
    func find(by id: Int) throws -> AnalysisResult?
    
    func save(_ elements: [AnalysisResult]) throws
    
    func edit(_ elements: [AnalysisResult]) throws
    
    func removeAll() throws
}
