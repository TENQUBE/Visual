//
//  File.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct ServerCategoryResponse: Codable  {

    let categories: [ServerCategory]
    let version: Int
}

struct ServerCategory: Codable {
    let id: Int
    let categoryCode: Int
    let largeCategory: String
    let mediumCategory: String
    let smallCategory: String
    let isDeleted: Int
    let isUpdated: Int
    let repCategoryCode: Int
    
}

