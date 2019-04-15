//
//  VisualRouter.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
// @link https://www.raywenderlich.com/35-alamofire-tutorial-getting-started
//
import Alamofire

public enum ResourceRouter: URLRequestConvertible {
    
    case version
    case category(Int, Int)
    case analysis(Int, Int)
    case parsingRule(Int, Int)

    var method: HTTPMethod {
        return .get
    }

    var headers: HTTPHeaders {
        switch self {
        default:
            return ["Content-Type": "application/json", "service": "ibk", "User-Agent" : "IOS"]
        }
    }
    
    var path: String {
        switch self {
        case .version:
            return "/resource/version"
        default:
            return "resource"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .parsingRule(let clientVersion, let serverVersion):
            return ["type":"parsingRule", "clientVersion": clientVersion, "serverVersion": serverVersion]
        case .category(let clientVersion, let serverVersion):
            return ["type":"category", "clientVersion": clientVersion, "serverVersion": serverVersion]
        case .analysis(let clientVersion, let serverVersion):
            return ["type":"analysis", "clientVersion": clientVersion, "serverVersion": serverVersion]
        default:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        guard let baseUrl = UserDefaults.standard.string(forKey: Constants.UDFKey.ResourceUrl) else {
            throw ApiError.invalidUrl
        }
        
        guard let apiKey = UserDefaults.standard.string(forKey: Constants.UDFKey.ResourceApiKey) else {
            throw ApiError.invalidApiKey
        }
        
        let base = baseUrl
        let url = try base.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        request.timeoutInterval = TimeInterval(5 * 1000)
        
        print("request", try URLEncoding.queryString.encode(request, with: parameters))
        return try URLEncoding.queryString.encode(request, with: parameters)
    }
}
