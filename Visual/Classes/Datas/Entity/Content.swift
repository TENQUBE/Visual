//
//  Advertisement.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation

public struct Content: DataProtocol {
 
    let id: Int
    let priority: Int
    let categoryPriority: Int
    let numOfOccurrence: Int
    let lCode: Int
    let rawKeys: String
    let linkTo: String
    let label: String
    let largeContent: String
    let largeKeys: String
    let mediumContent: String
    let mediumKeys: String
    let image: String
    
    var conditions: [Condition]?
    
    init(_ param: ContentParams) {

        self.id = param.id
        self.priority = param.priority
        self.categoryPriority = param.categoryPriority
        self.numOfOccurrence = param.numOfOccurrence
        self.lCode = param.lCode
        self.rawKeys = param.rawKeys
        self.linkTo = param.linkTo
        self.label = param.label
        self.largeContent = param.largeContent
        self.largeKeys = param.largeKeys
        self.mediumContent = param.mediumContent
        self.mediumKeys = param.mediumKeys
        self.image = param.image
        
    }
    
    func checkParams() throws {
        
    }
}
