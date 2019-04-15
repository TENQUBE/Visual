//
//  File.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct AnalysisResponse: Codable  {

    let version: Int
    
    let contents: [ServerContent]
    
}

struct ServerContent: Codable {
    let id: Int
    let priority: Int
    let categoryPriority: Int
    let numOfOccurence: Int
    let lCode: Int
    let label: String
    let linkTo: String
    let rawKeys: String
    let lContent: String
    let lKeys: String
    let mContent: String
    let mKeys: String
    let image: String
    let conditions: [ServerCondition]
    let enable: Int
    
}

struct ServerCondition: Codable {
    let id: Int
    let standard: String
    let funcType: String
    let funcKeys: String
    let enable: Int
}

