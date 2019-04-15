//
//  VisualRouter.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
// @link https://www.raywenderlich.com/35-alamofire-tutorial-getting-started
// 
import Alamofire

public enum SearchRouter: URLRequestConvertible {
 
  
    case searchCompany(SearchCompanyRequest)

    var method: HTTPMethod {
        switch self {
        case .searchCompany:
            return .post
    
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .searchCompany(let searchCompanyRequest):
            return searchCompanyRequest.dictionary
        }
    }
    
    var headers: HTTPHeaders {
        
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        guard let searchUrl = UserDefaults.standard.string(forKey: Constants.UDFKey.SearchUrl), let url = URL(string: searchUrl) else {
            throw ApiError.invalidUrl
        }
        
        guard let apiKey = UserDefaults.standard.string(forKey: Constants.UDFKey.SearchApiKey) else {
            throw ApiError.invalidApiKey
        }
        
        guard let uid = UserDefaults.standard.string(forKey: Constants.UDFKey.UID) else {
            throw ApiError.invalidUID
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        request.addValue(uid, forHTTPHeaderField: "Authorization")
        
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return try JSONEncoding.default.encode(request, with: parameters)
    }
}
