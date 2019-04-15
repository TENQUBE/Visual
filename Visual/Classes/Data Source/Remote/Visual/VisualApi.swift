//
//  RegRule.swift
//  Parser
//
//  Created by tenqube on 2019/02/12.
//  Copyright © 2019 tenqube. All rights reserved.
//

class VisualApi: VisualApiService {
  
    private let apiManager: AlamofireManager

    init(apiManager: AlamofireManager) {
        self.apiManager = apiManager
    }
    
    func signUp(uid: String, callback: @escaping (_ response: SignUpResponse?, _ err: Error?)->()) {

        self.apiManager.call(type: VisualRouter.signUp(uid)) { (response: SignUpResponse?, err: Error?) in
            callback(response, nil)
        }
    }
    
    func getCurrency(from: String, to: String, callback: @escaping (CurrencyResponse?, Error?) -> ()) {
        self.apiManager.call(type: VisualRouter.currency(from, to)) { (response: CurrencyResponse?, err: Error?) in
            callback(response, nil)
        }
    }
    
    func saveTransactions(request: TransactionRequest, callback: @escaping (Bool?, Error?) -> ()) {
        print(request)
        self.apiManager.call(type: VisualRouter.transaction(request)) { (response: Bool?, err: Error?) in
            callback(response, nil)
        }
    }
    
    func getAds(version: Int, callback: @escaping (AdResponse?, Error?) -> ()) {
        self.apiManager.call(type: VisualRouter.ad(version)) { (response: AdResponse?, err: Error?) in
            callback(response, nil)
        }
    }

}
