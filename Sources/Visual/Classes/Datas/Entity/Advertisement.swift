//
//  Advertisement.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation
public struct Advertisement: DataProtocol {
 
    
    let id: Int
    let title: String
    let label: String
    let content: String
    let linkTo: String
    let linkToType: String
    let linkToStr: String
    let image: String
    let iconImage: String
    let priority: Int
    let query: String
    
    init(_ param: AdvertisementParams) {
        
        self.id = param.id
        self.title = param.title
        self.label = param.label
        self.content = param.content
        self.linkTo = param.linkTo
        self.linkToType = param.linkToType
        self.linkToStr = param.linkToStr
        self.image = param.image
        self.iconImage = param.iconImage
        self.priority = param.priority
        self.query = param.query
    }
    
    func checkParams() throws {
        
    }
}
