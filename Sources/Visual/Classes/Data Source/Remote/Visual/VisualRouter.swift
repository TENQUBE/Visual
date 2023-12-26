//
//  VisualRouter.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
// @link https://www.raywenderlich.com/35-alamofire-tutorial-getting-started
// 
import Alamofire

public enum VisualRouter: URLRequestConvertible {
 
    var baseURL: String {

        return "https://ibk.tenqube.kr/"
    }
    
    case signUp(String)
    case currency(String, String)
    case transaction(TransactionRequest)
    case ad(Int)
    
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        case .currency:
            return .get
        case .transaction:
            return .post
        case .ad:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/users/sign-up"
        case .currency(let from, let to):
            return "/currency/rate/\(from)/\(to)"
        case .transaction:
            return "/transaction"
        case .ad(let version):
            return "/ad/\(version)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .signUp(let uid):
            return ["uid": uid]
        case .transaction(let transaction):
            return transaction.dictionary ?? [:]
        default:
            return [:]
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var encodeing: ParameterEncoding {
        switch self {
        case .ad:
            return URLEncoding.default
        default:
            return JSONEncoding.default
            
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        guard let apiKey = UserDefaults.standard.string(forKey: Constants.UDFKey.ApiKey) else {
            throw ApiError.invalidApiKey
        }
        
        let base = baseURL + (UserDefaults.standard.string(forKey: Constants.UDFKey.Layer) ?? "dev")
        let url = try base.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.timeoutInterval = TimeInterval(5 * 1000)
        
        switch self {
        case .signUp:
            break
        default:
            guard let uid = UserDefaults.standard.string(forKey: Constants.UDFKey.UID) else {
                throw ApiError.invalidUID
            }
            request.setValue(uid, forHTTPHeaderField: "Authorization")
        }
        
        return try encodeing.encode(request, with: parameters)
    }
}
