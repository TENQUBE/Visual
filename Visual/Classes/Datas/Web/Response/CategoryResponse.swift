//
//  File.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct CategoryResponse: Codable {
    let serverCategory: [ServerCategoryInfo]
    let userCategory: [UserCategoryInfo]
    
    init(server: [ServerCategoryInfo], user: [UserCategoryInfo]) {
        self.serverCategory = server
        self.userCategory = user
    }
}

struct ServerCategoryInfo: Codable {
    
    let categoryId: Int
    let largeCategory: String
    let mediumCategory: String
    let categoryCode: Int
    
    init(categoryId: Int, largeCategory: String, mediumCategory: String, categoryCode: Int) {
        self.categoryId = categoryId
        self.largeCategory = largeCategory
        self.mediumCategory = mediumCategory
        self.categoryCode = categoryCode
    }
    

}

struct UserCategoryInfo: Codable {
    let cateConfigId: Int
    let categoryCode: Int
    let mainType: Int
    let exceptType: Int
    
    init(cateConfigId: Int, categoryCode: Int, mainType: Int, exceptType: Int) {
        self.cateConfigId = cateConfigId
        self.categoryCode = categoryCode
        self.mainType = mainType
        self.exceptType = exceptType
    }
    
    
}
