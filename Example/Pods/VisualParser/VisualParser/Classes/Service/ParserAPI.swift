//
//  ApiService.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/25.
//  Copyright © 2019 tenqube. All rights reserved.
//

public protocol ParserAPI {
    func searchCompany(reqData: [SearchCompanyRequestData], completion: @escaping (Error?, [SearchCompanyResponseData]?) -> Void)
    func getCurrency(reqData: [CurrencyRequestData], completion: @escaping ([CurrencyResponseData]) -> Void)
}
