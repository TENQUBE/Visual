//
//  ParserApiServiceImpl.swift
//  Visual
//
//  Created by tenqube on 21/03/2019.
//

import Foundation
import VisualParser

class ParserApiServiceImpl: ParserAPI {
    
    let resouceApi: ResourceApiService
    let searchManager: SearchManager
    let currencyDao: CurrencyDataSource
    let appExecutor: AppExecutors
    
    //TODO search manager 로 변경
    init(resourceApi: ResourceApiService,
         searchManager: SearchManager,
         currencyDao: CurrencyDataSource,
         appExecutor: AppExecutors) {
        
        self.resouceApi = resourceApi
        self.searchManager = searchManager
        self.currencyDao = currencyDao
        self.appExecutor = appExecutor
    }
    
    func searchCompany(reqData: [SearchCompanyRequestData], completion:
        @escaping (Error?, [SearchCompanyResponseData]?) -> Void){
        
        if reqData.count == 0 {
            completion(nil, self.toSearchResponse(res: SearchCompanyResponse(results: [])))
        } else {
            self.searchManager.searchCompany(reqData: toSearchRequest(reqData: reqData)) { (err, res) in
                
                completion(err, self.toSearchResponse(res: res))
            }
        }
    
    }
    
    private func toSearchRequest(reqData: [SearchCompanyRequestData]) -> SearchCompanyRequest  {
        var searchInfos = [SearchInfo]()
        
        for search in reqData {
            do {
                let searchInfo = try SearchInfo(id: search.id,
                                                keyword: search.keyword,
                                                type: search.type,
                                                at: search.at,
                                                method: search.method,
                                                amount: search.amount,
                                                amountType: search.amountType,
                                                lat: search.lat,
                                                long: search.long, lCode: nil, mCode: nil)
                
                searchInfos.append(searchInfo)
            } catch {
                continue
            }
            
        }
        
        return SearchCompanyRequest(transactions: searchInfos)
    }
    
    private func toSearchResponse(res: SearchCompanyResponse) -> [SearchCompanyResponseData] {
        var results = [SearchCompanyResponseData]()
        
        for tran in res.results {
            
            results.append(SearchCompanyResponseData((
                id: tran.id,
                oriKeyword: tran.keyword.ori,
                searchKeyword: tran.keyword.search,
                companyId: tran.company.id,
                companyName: tran.company.name,
                companyAddress: tran.company.address,
                categoryCode: tran.category.code,
                classCode: tran.classCode,
                isPopUpCompanyName: tran.isPopUpCompanyName)))
        }
        
        return results

    }
    
    func getCurrency(reqData: [CurrencyRequestData], completion: @escaping ([CurrencyResponseData]) -> Void) {
        
        self.appExecutor.diskIO.async {
            
            do {
              
                let currencyDict = Dictionary(grouping: reqData, by: {
                    $0.from + $0.to
                })
                
                var fromTo = [(String, String)]()
                for (_, value) in currencyDict {
                     fromTo.append((value[0].from, value[0].to))
                }
   
                let currencies = try self.currencyDao.find(by: fromTo)
                
                let results = currencies.map {
                    CurrencyResponseData(from: $0.from, to: $0.to, rate: $0.rate)
                }
                
                self.appExecutor.mainThread.async {
                    completion(results)
                    
                }
            } catch {
                self.appExecutor.mainThread.async {
                    completion([])
                    
                }
            }
           
            
        }
        
    }
    
   
}
