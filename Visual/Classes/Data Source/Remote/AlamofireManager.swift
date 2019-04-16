//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//  @reference : https://medium.com/@pavlepesic/alamofire-api-manager-5b30c89477a1
//

import Alamofire
import SwiftyJSON

class AlamofireManager {
    
    enum NetworkEnvironment {
        case dev
        case prod
    }
    
    private let session: SessionManager

    
    init(session: Alamofire.SessionManager) {
        self.session = session
    }
    
    func call<T>(type: URLRequestConvertible, callback: @escaping (T?, _ error: Error?)->()) where T: Codable {
            
        self.session.request(type).debugLog().validate().responseData { response in
                                        switch response.result {
                                        case .success(_):
                                            print("success")
                                            do {
                                                let decoder = JSONDecoder()
                                                if let jsonData = response.data {
                                                    print("json", JSON(jsonData))
                                                    let result = try decoder.decode(T.self, from: jsonData)
                                                    callback(result, nil)
                                                } else {
                                                    callback(nil, nil)
                                                }
                                            } catch {
                                                
                                                print("json error", response.data ?? "nil")
                                                callback(nil, nil)
                                            }
                                           
                                            break
                                        case .failure(let fail):
                                            print("fail", fail)
                                            callback(nil, fail)
                                            break
                                        }
        }
    }
}
