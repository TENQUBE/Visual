//
//  ParserApiService.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/25.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Alamofire
import SwiftyJSON

public class ParserAPIService: ParserAPI {
    private var apiDataDict = [String: ParserAPIData]()
    private let sessionManager: SessionManager
    private let defaultAPITimeoutSec = 1.0

    private enum ParserAPIServiceError: Error {
        case canNotInitParserAPIService
        case emptyParserAPIData
        case emptySearchAPIData
    }

    public init(apiDatas: [ParserAPIData]) throws {
        if apiDatas.isEmpty {
            throw ParserAPIServiceError.canNotInitParserAPIService
        }

        for apiData in apiDatas {
            apiDataDict[apiData.name] = apiData
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = defaultAPITimeoutSec
        config.timeoutIntervalForResource = defaultAPITimeoutSec

        sessionManager = Alamofire.SessionManager(configuration: config)
    }

    public func searchCompany(reqData: [SearchCompanyRequestData],
                              completion: @escaping (Error?, [SearchCompanyResponseData]?) -> Void) {
        guard let searchAPI = apiDataDict["search"] else {
            return completion(ParserAPIServiceError.emptySearchAPIData, nil)
        }

        sessionManager.request(
            searchAPI.url,
            method: .post,
            parameters: ["transactions": reqData.map({ $0.toAPIParameters() })],
            encoding: JSONEncoding.default,
            headers: ["x-api-key": searchAPI.key,
                      "Content-Type": "application/json",
                      "Authorization": searchAPI.auth]
            ).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var resDatas: [SearchCompanyResponseData] = []

                    guard let results = json["results"].array else {
                        return completion(nil, [])
                    }

                    for result in results {
                        guard let isPopUpCompanyName = result["isPopUpCompanyName"].bool,
                            let keyword = result["keyword"].dictionary,
                            let oriKeyword = keyword["ori"]?.string,
                            let searchKeyword = keyword["search"]?.string,
                            let id = result["id"].string,
                            let company = result["company"].dictionary,
                            let companyId = company["id"]?.int,
                            let companyName = company["name"]?.string,
                            let companyAddress = company["address"]?.string,
                            let classCode = result["classCode"].string,
                            let category = result["category"].dictionary,
                            let categoryCode = category["code"]?.int
                            else {
                                continue
                        }

                        resDatas.append(SearchCompanyResponseData((id: id,
                                                                   oriKeyword: oriKeyword,
                                                                   searchKeyword: searchKeyword,
                                                                   companyId: companyId,
                                                                   companyName: companyName,
                                                                   companyAddress: companyAddress,
                                                                   categoryCode: categoryCode,
                                                                   classCode: classCode,
                                                                   isPopUpCompanyName: isPopUpCompanyName)))
                    }

                    completion(nil, resDatas)
                case .failure(let error):
                    completion(error, nil)
                }
        }
    }

    public func getCurrency(reqData: [CurrencyRequestData], completion: @escaping ([CurrencyResponseData]) -> Void) {
        var results: [CurrencyResponseData] = []

        for req in reqData {
            results.append(CurrencyResponseData(from: req.from, to: req.to, rate: 1))
        }

        return completion(results)
    }
}
