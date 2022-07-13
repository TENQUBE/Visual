//
//  File.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public struct SearchCompanyResponse: Codable  {
    
    let results: [TranCompany]
    
    init(results: [TranCompany]) {
        self.results = results
    }
    
}

public struct TranCompany: Codable {
    
    let id: String
    
    let classCode: String
    
    let company: Company
    
    let category: CompanyCategory
    
    let keyword: Keyword
    
    let isPopUpCompanyName: Bool
    
    init(id: String, classCode: String, company: Company, category: CompanyCategory, keyword: Keyword, isPopUpCompanyName: Bool) {
        self.id = id
        self.classCode = classCode
        self.company = company
        self.category = category
        self.keyword = keyword
        self.isPopUpCompanyName = isPopUpCompanyName
    }
}

public struct Company: Codable {
    
    let id: Int
    
    let name: String
    
    let address: String
    
    init(id: Int, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
    
}

public struct CompanyCategory: Codable {
    let code: Int
    
    init(code: Int) {
        self.code = code
    }
}

public struct Keyword: Codable {
    let ori: String
    let search: String
    
    init(ori: String, search: String) {
        self.ori = ori
        self.search = search
    }
}
