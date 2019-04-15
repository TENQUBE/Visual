//
//  UserCategory.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct UserCategory: DataProtocol {
    let id: Int
    let code: Int
    let isExcept: Bool

    
    init(_ param: UserCategoryParams) {
        
        self.id = param.id
        self.code = param.code
        self.isExcept = param.isExcept

    }
    
    func checkParams() throws {
        
    }
}
