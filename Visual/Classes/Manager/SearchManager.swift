//
//  SearchManager.swift
//  Visual
//
//  Created by tenqube on 28/03/2019.
//

import Foundation
class SearchManager {
    
    let searchApi: SearchApiService
    let transactionDao: TransactionDataSource

    init(searchApi: SearchApiService, transactionDao: TransactionDataSource) {
    
        self.searchApi = searchApi
        self.transactionDao = transactionDao
    }
    
    func searchCompanyForParser(reqData: SearchCompanyRequest,  completion:
        @escaping (Error?, SearchCompanyResponse) -> Void){
        
        searchCompanyFromDBForApplyAll(reqData: reqData) { (reqData, res) in
            if reqData.transactions.count != 0 {
                // reqData 로컬에서 걸리고 난 나머지
                // res 로컬에서 찾아진 결과
                self.searchCompany(reqData: reqData, completion: completion)
                return
            }
            completion(nil, res) // 모든 정보가 로컬디비에서 찾아짐
        }
    }
    
    func searchCompany(reqData: SearchCompanyRequest,  completion:
        @escaping (Error?, SearchCompanyResponse) -> Void){
        
        searchCompanyFromDB(reqData: reqData) { (reqData, res) in
            if reqData.transactions.count != 0 {
                // reqData 로컬에서 걸리고 난 나머지
                // res 로컬에서 찾아진 결과
                self.searchCompanyFromApi(reqData: reqData, localData: res, completion: completion)
                return
            }
            completion(nil, res) // 모든 정보가 로컬디비에서 찾아짐
        }
        
    }
    
    private func searchCompanyFromDBForApplyAll(reqData: SearchCompanyRequest,  completion:
        @escaping (SearchCompanyRequest, SearchCompanyResponse) -> Void) {
        do {
            
            let searchInfos = reqData.transactions
            
            let keywords = searchInfos.map {
                $0.keyword
            }
            
            let distinctKeywords = Array(Set(keywords))
            
            var transactions = try self.transactionDao.findForApplyAll(by: distinctKeywords)
            
   
            print("fromDbApplyAll", transactions)
            
            transactions = transactions.filter {
                $0.dwType == 0 || $0.dwType == 1
            }
            
            let tranDict = Dictionary(grouping: transactions, by: {
                $0.keyword + DwType(rawValue: $0.dwType)!.str
            })
            
            var distinctTransactions = [Transaction]()
            
            for (_, values) in tranDict {
                guard let maxTransaction = values.max(by: { (a, b) -> Bool in
                    if a.spentDate == b.spentDate {
                        
                        return a.id < b.id
                        
                    } else {
                        return a.spentDate < b.spentDate
                    }
                }) else {
                    continue
                }
                
                distinctTransactions.append(maxTransaction)
            }
            
            let notSearchedRequest = searchInfos.filter {
                return tranDict[$0.keyword + $0.type] == nil
            }
            
            var results = [TranCompany]()
            
            for tran in distinctTransactions {
                let id = String(tran.id)
                let classCode = tran.classCode
                let company = Company(id: tran.companyId, name: tran.companyName, address: tran.companyAddress)
                let category = CompanyCategory(code: tran.code)
                let keyword = Keyword(ori: tran.keyword, search: tran.searchKeyword)
                let isPopUpCompanyName = tran.isPopUpCompanyName
                
                let tranCompany = TranCompany(id: id, classCode: classCode, company: company, category: category, keyword: keyword, isPopUpCompanyName: isPopUpCompanyName)
                
                results.append(tranCompany)
                
            }
            
            completion(SearchCompanyRequest(transactions: notSearchedRequest), SearchCompanyResponse(results: results))
            
        } catch {
            completion(reqData, SearchCompanyResponse(results: []))
        }
        
    }
    
    
    private func searchCompanyFromDB(reqData: SearchCompanyRequest,  completion:
        @escaping (SearchCompanyRequest, SearchCompanyResponse) -> Void) {
        do {
            
            let searchInfos = reqData.transactions
            
            let keywords = searchInfos.map {
                $0.keyword
            }
            
            let distinctKeywords = Array(Set(keywords))
            
            var transactions = try self.transactionDao.find(by: distinctKeywords)
            
            print("fromDb", transactions)
                
            transactions = transactions.filter {
                $0.dwType == 0 || $0.dwType == 1
            }

            let tranDict = Dictionary(grouping: transactions, by: {
                "\( $0.keyword)\(DwType(rawValue: $0.dwType)!.str)\($0.toLcode())\($0.toMcode())"
            })
            
            var distinctTransDict = [String:Transaction]()
            
            for (key, values) in tranDict {
                guard let maxTransaction = values.max(by: { (a, b) -> Bool in
                    if a.spentDate == b.spentDate {
                        
                        return a.id < b.id
                        
                    } else {
                        return a.spentDate < b.spentDate
                    }
                }) else {
                    continue
                }
                distinctTransDict[key] = maxTransaction
            }
            
            var notMatchedReq = [SearchInfo]()
            var results = [TranCompany]()
            
            for search in reqData.transactions {
                // transaction 에서 keyword, type, lcode or lcode mcode 인 데이터 찾기
                if let tran = distinctTransDict["\(search.keyword)\(search.type)\(search.lCode ?? 0)\(search.mCode ?? 0)"] {
                    let id = String(tran.id)
                    let classCode = tran.classCode
                    let company = Company(id: tran.companyId, name: tran.companyName, address: tran.companyAddress)
                    let category = CompanyCategory(code: tran.code)
                    let keyword = Keyword(ori: tran.keyword, search: tran.searchKeyword)
                    let isPopUpCompanyName = tran.isPopUpCompanyName
                    
                    let tranCompany = TranCompany(id: id, classCode: classCode, company: company, category: category, keyword: keyword, isPopUpCompanyName: isPopUpCompanyName)
                    
                    results.append(tranCompany)
                } else {
                    notMatchedReq.append(search)
                }
            }
            
            completion(SearchCompanyRequest(transactions: notMatchedReq), SearchCompanyResponse(results: results))
            
        } catch {
            completion(reqData, SearchCompanyResponse(results: []))
        }
        
    }
    
    private func searchCompanyFromApi(reqData: SearchCompanyRequest, localData: SearchCompanyResponse, completion:
        @escaping (Error?, SearchCompanyResponse) -> Void) {
       
        self.searchApi.search(request: reqData) { (res, err) in
            
            print("search", res)
            
            let results = res.results + localData.results
            
            completion(err, SearchCompanyResponse(results: results))
        }
    }
}
