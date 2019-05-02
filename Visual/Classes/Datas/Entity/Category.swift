//
//  Advertisement.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct Category: DataProtocol {
    let id: Int
    let code: Int
    let large: String
    let medium: String
    let small: String

    
    init(_ param: CategoryParams) {
        
        self.id = param.id
        self.code = param.code
        self.large = param.large
        self.medium = param.medium
        self.small = param.small
        
    }
    
    func getLcode() -> String {
        let lcode = String(code)[0..<2]
        return lcode
    }
    
    func getMcode() -> String {
        let mcode = String(code)[2..<4]
        return mcode
    }
    
    func getScode() -> String {
        return String(code)[4..<6]
    }
    
    func checkParams() throws {
        
    }
}
