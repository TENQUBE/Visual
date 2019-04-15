//
//  Error.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
enum ParameterError: Error {
    case invalidValue(type: String, name: String)
}

enum DBError: Error {
    case canNotInit
}

enum ValidatorError: Error {
    case notSupportType
}

enum ApiError: Error {
    case invalidUrl
    case invalidUID
    case invalidApiKey
}

struct ValidationError: Error {
    
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}
