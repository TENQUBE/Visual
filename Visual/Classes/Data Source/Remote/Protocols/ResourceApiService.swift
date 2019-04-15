//
//  VisualApiService.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol ResourceApiService {
    
    func getVersions(callback: @escaping (_ response: VersionResponse?, _ error: Error?)->())
    
    func syncCategory(clientVersion: Int, serverVersion: Int, callback: @escaping (_ response: ServerCategoryResponse?, _ error: Error?)->())

    func syncAnalysis(clientVersion: Int, serverVersion: Int, callback: @escaping (_ response: AnalysisResponse?, _ error: Error?)->())
    
    func syncParsingRule(clientVersion: Int, serverVersion: Int, callback: @escaping (ParserResponse?, _ error: Error?) -> ())
    

}
