//
//  File.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct SignUpResponse: Codable  {
    
    let results: Result
    
}

public struct Result: Codable {
    let secretKey: String
    let resource: Resource
    let search: Search
    let web: Web
    let authorization: Authorization
}

public struct Search: Codable {
    let url: String
    let apiKey: String
    
}

public struct Web: Codable {
    let url: String
    let iosUrl: String
}

public struct Authorization: Codable {
    
    let sdk: String

}

public struct Resource: Codable {
    let url: String
    let apiKey: String
}


