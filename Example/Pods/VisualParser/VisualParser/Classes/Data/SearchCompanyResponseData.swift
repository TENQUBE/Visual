//
//  SearchCompanyResponseData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

public struct SearchCompanyResponseData {
    public let id: String
    public let oriKeyword: String
    public let searchKeyword: String
    public let companyId: Int
    public let companyName: String
    public let companyAddress: String
    public let categoryCode: Int
    public let classCode: String
    public let isPopUpCompanyName: Bool

    public init(_ params: SearchCompanyResponseParams) {
        id = params.id
        oriKeyword = params.oriKeyword
        searchKeyword = params.searchKeyword
        companyId = params.companyId
        companyName = params.companyName
        companyAddress = params.companyAddress
        categoryCode = params.categoryCode
        classCode = params.classCode
        isPopUpCompanyName = params.isPopUpCompanyName
    }
}

public struct SearchCompanyResponse: Codable  {

    let results: [TranCompany]

    init(results: [TranCompany]) {
        self.results = results
    }
}

public struct KeywordData: Codable {
    let ori: String
    let search: String

    init(ori: String, search: String) {
        self.ori = ori
        self.search = search
    }
}

public struct TranCompany: Codable {

    let id: String

    let classCode: String

    let company: Company

    let category: CompanyCategory

    let keyword: KeywordData

    let isPopUpCompanyName: Bool

    init(id: String, classCode: String, company: Company, category: CompanyCategory, keyword: KeywordData, isPopUpCompanyName: Bool) {
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


