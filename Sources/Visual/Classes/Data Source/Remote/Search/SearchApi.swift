//
//  RegRule.swift
//  Parser
//
//  Created by tenqube on 2019/02/12.
//  Copyright © 2019 tenqube. All rights reserved.
//

class SearchApi: SearchApiService {
//
    private let apiManager: AlamofireManager

    init(apiManager: AlamofireManager) {
        self.apiManager = apiManager
    }
    
    func search(request: SearchCompanyRequest, callback: @escaping (_ response: SearchCompanyResponse, _ error: Error?)->()) {
        
        self.apiManager.call(type: SearchRouter.searchCompany(request)) { (response: SearchCompanyResponse?, message: Error?) in
            
            guard let res = response else {
                var results = [TranCompany]()
                
                var code = SearchCompany.deposit.code
                var companyId = SearchCompany.deposit.id
                var classCode = SearchCompany.deposit.classCode
                var companyTitle = SearchCompany.deposit.title
             
                for searchInfo in request.transactions {
                    
                    switch (searchInfo.type, searchInfo.amountType) {
                    case (DwType.withdraw.str, CardType.account.search): //출금
                        code = SearchCompany.withdraw.code
                        companyId = SearchCompany.withdraw.id
                        classCode = SearchCompany.withdraw.classCode
                        companyTitle = SearchCompany.withdraw.title
                        break
                    case (DwType.withdraw.str, _)://미분류
                        code = SearchCompany.uncate.code
                        companyId = SearchCompany.uncate.id
                        classCode = SearchCompany.uncate.classCode
                        companyTitle = SearchCompany.uncate.title
                        break
                    default:// 입금
                        code = SearchCompany.deposit.code
                        companyId = SearchCompany.deposit.id
                        classCode = SearchCompany.deposit.classCode
                        companyTitle = SearchCompany.deposit.title
                        break
                    }
                    
                  
                    let category = CompanyCategory(code: code)
                    let keyword = Keyword(ori: searchInfo.keyword, search: searchInfo.keyword)
                    let company = Company(id: companyId, name: companyTitle , address: "")
                    let tranCompany = TranCompany(id: request.transactions[0].id,
                                                  classCode: classCode,
                                                  company: company,
                                                  category: category,
                                                  keyword: keyword,
                                                  isPopUpCompanyName: false)
                    results.append(tranCompany)
                    
                } // end for
                
                callback(SearchCompanyResponse(results: results), nil)
                return
            } // end guard
           
            callback(res, nil)

        }
    }

}
